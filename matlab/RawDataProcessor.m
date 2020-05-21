classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}

        Number_period;
        sampling_frequency;
        max_angle_per;
        min_angle_per;

        max_torque_per;
        min_torque_per;
        theta_8;
        torque_8;

        max_Shearforceper;
        min_Shearforceper;
        mean_Shearforceper;
        bpoint;

        max_Shearstrainper;
        min_Shearstrainper;
        mean_Shearstrainper;

        TauMaxMPa;
        TauMinMPa;
        TauMeanMPa;
        Strain_TotMax;
        Strain_TotMin_;
        Strain_TotMean;
        StrainRate;

        max_Shearforceperimproved;
        min_Shearforceperimproved;
        
        Shearforce;
        Shearstrain;
        
        ename;
    end %public properties
    
    properties (Access=private)
        frequncy_ =0.1;
        sampling_ = 16;
        sradius_ = 3;
        slength_ = 20;

        datasource_ = 'cloudlab';
        username_ = 'cloudlab';
        passwd_ = 'CloudLab-!@#$';
        conn_;
    end %private properties

    methods (Access=public)        
        function this = raw_data_by_param(this, path, ftype)
            [Ts, Angle, Torque] = read_raw_data_(this, path, ftype);
            insert_to_db(this, Ts, Angle, Torque);
            this.len = length(Torque);
        end % raw_data

        function this = raw_data_from_db_by_eid(this, eid)
            this.conn_ = database(this.datasource_, this.username_, ...,
                this.passwd_);
            
            [path, ftype, this.ename] = get_path_by_eid_(this, eid);            
            [Angle, Torque] = read_raw_data_(this, path, ftype);
            close(this.conn_);

            this.len = length(Torque);

            this = process_rawdata_(this, Angle, Torque);

            plot_original_(this, this.max_angle_per, this.min_angle_per, 'o');
            plot_original_(this, this.max_torque_per, this.min_torque_per, 'v');            
        end % raw_data

        function this = raw_data(this)
            this.conn_ = database(this.datasource_, this.username_, ...,
                this.passwd_);

            eid = get_all_eid_(this);
            for i = 1 : length(eid)
                fprintf("Experiment %d ... ", i);
                [path, ftype, ename] = get_path_by_eid_(this, eid(i));
                [Angle, Torque] = read_raw_data_(this, path, ftype);
                fprintf("Length is %d ... ", length(Torque));
                % insert_to_rawdata_table(this, eid(i), rawtable, Angle, Torque);
                fprintf("Done.\n");
            end
            
            close(this.conn_);
        end % raw_data
    end % public methods

    methods (Access=private)
        function [Angle, Torque] = read_raw_data_(this, path, ftype)
            path=[path, '\'];
            file_list_new = dir([path,'*.txt']);
            l=length(file_list_new);
            file_list_temp1=sort_nat({file_list_new.name});
            file_list=file_list_temp1(:);

            Angle=[];
            Torque=[];
            for i=1:l
                file_name{i}=[path,file_list{i}];
                
                if (ftype == 1)
                    [data1,data2,data3,data4,data5,data6,data7, ...,
                        data8,data9, data10]=textread(file_name{i}, ...,
                        '%f%f%f%f%f%f%f%f%f%f','headerlines',1);
                    % Ts=[Ts;data1];
                    Angle=[Angle;data2];
                    Torque=[Torque;data6];
                else
                    [~,data2,data3]=textread(file_name{i}, ...,
                        '%f%f%f','headerlines',1);
                    % Ts=[Ts;data1];
                    Torque=[Torque;data2];
                    Angle=[Angle;data3];
                end %if
            end % for
        end % function read_raw_data

        function [path, ftype, rawtable] = get_path_by_eid_(this, eid)
            sql = ['SELECT `datapath`, `datatype`, `rawtable` FROM `experiment` WHERE `eid` = ', ... ,
                int2str(eid)];
            res = fetch(this.conn_, sql);
            path = char(res.datapath(1));
            ftype = res.datatype(1);
            rawtable = char(res.rawtable(1));
        end

        function eid = get_all_eid_(this)
            sql = 'SELECT `eid` FROM `experiment`';
            res = fetch(this.conn_, sql);
            eid = res.eid;
        end %get_all_eid_
        
        function good = insert_to_rawdata_table(this, eid, rawtable, ...,
                Angle, Torque)
            Eid = ones(length(Torque), 1) * eid;
            data = table(Eid, Angle, Torque, 'VariableNames',{'eid', 'torque', 'angle'});
            sqlwrite(this.conn_, rawtable, data);
            commit(this.conn_);
            good = 1;
        end
        
        function this = process_rawdata_(this, Angle, Torque)
            Angle = Angle * pi / 180;
            this.sampling_frequency = this.sampling_/this.frequncy_;
            
            %处理Theta, Torque
            Num=length(Angle);
            this.Number_period = 0;
            for period = 1:Num
                if period * this.sampling_frequency <= Num
                    this.max_angle_per(period,1)=max(Angle((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.max_angle_per(period,2)=period;

                    this.min_angle_per(period,1)=min(Angle((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.min_angle_per(period,2)=period;

                    this.max_torque_per(period,1)=max(Torque((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.max_torque_per(period,2)=period;

                    this.min_torque_per(period,1)=min(Torque((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.min_torque_per(period,2)=period;

                    this.Number_period = period;
                else
                    this.max_angle_per(period,1)=max(Angle((period-1) * this.sampling_frequency + 1:Num));
                    this.max_angle_per(period,2)=period;

                    this.min_angle_per(period,1)=min(Angle((period-1) * this.sampling_frequency + 1:Num));
                    this.min_angle_per(period,2)=period;

                    this.max_torque_per(period,1)=max(Torque((period-1) * this.sampling_frequency + 1:Num));
                    this.max_torque_per(period,2)=period;

                    this.min_torque_per(period,1)=min(Torque((period-1) * this.sampling_frequency + 1:Num));
                    this.min_torque_per(period,2)=period;
                    break;
                end
            end
            
            %去除坏点 Angle
            max_angle_permean=mean(this.max_angle_per);
            max_angle_perstd=std(this.max_angle_per);
            min_angle_permean=mean(this.min_angle_per);
            min_angle_perstd=std(this.min_angle_per);
            for i=1:this.Number_period + 1
                if (this.max_angle_per(i,1)>(max_angle_permean(1,1) + 3 * max_angle_perstd(1,1))) || (this.max_angle_per(i,1)<(max_angle_permean(1,1)-3*max_angle_perstd(1,1)))
                    this.max_angle_per(i,1) = max_angle_permean(1,1);
                end
                if (this.min_angle_per(i,1)>(min_angle_permean(1,1) + 3 * min_angle_perstd(1,1))) || (this.min_angle_per(i,1)<(min_angle_permean(1,1)-3*min_angle_perstd(1,1)))
                    this.min_angle_per(i,1) = min_angle_permean(1,1);
                end
            end

            % Torque 对中操作
            move_distance = 0.5 * (this.max_torque_per(:,1) - this.min_torque_per(:,1)) - this.max_torque_per(:,1);
            this.max_torque_per(:,1) = this.max_torque_per(:,1) + move_distance(:,1);
            this.min_torque_per(:,1) = this.min_torque_per(:,1) + move_distance(:,1);
        end % process_rawdata_

        function this = process_rawdata_1_(this, Angle, Torque)
            Angle = Angle * pi / 180;
            this.sampling_frequency = this.sampling_/this.frequncy_;
            
            %处理Theta, Torque
            Num=length(Angle);
            this.Number_period = 0;
            for period = 1:Num
                if period * this.sampling_frequency <= Num
                    this.max_angle_per(period,1)=max(Angle((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.max_angle_per(period,2)=period;

                    this.min_angle_per(period,1)=min(Angle((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.min_angle_per(period,2)=period;

                    this.max_torque_per(period,1)=max(Torque((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.max_torque_per(period,2)=period;

                    this.min_torque_per(period,1)=min(Torque((period-1) * this.sampling_frequency + 1:period * this.sampling_frequency));
                    this.min_torque_per(period,2)=period;

                    this.Number_period = period;
                    period = period + 1;
                else
                    this.max_angle_per(period,1)=max(Angle((period-1) * this.sampling_frequency + 1:Num));
                    this.max_angle_per(period,2)=period;

                    this.min_angle_per(period,1)=min(Angle((period-1) * this.sampling_frequency + 1:Num));
                    this.min_angle_per(period,2)=period;

                    this.max_torque_per(period,1)=max(Torque((period-1) * this.sampling_frequency + 1:Num));
                    this.max_torque_per(period,2)=period;

                    this.min_torque_per(period,1)=min(Torque((period-1) * this.sampling_frequency + 1:Num));
                    this.min_torque_per(period,2)=period;
                    break;
                end
            end

            % Torque 对中操作
            move_distance = 0.5 * (this.max_torque_per - this.min_torque_per) - this.max_torque_per;
            this.max_torque_per = this.max_torque_per + move_distance;
            this.min_torque_per = this.min_torque_per + move_distance;
            
            %去除坏点 Angle
            max_angle_permean=mean(this.max_angle_per);
            max_angle_perstd=std(this.max_angle_per);
            min_angle_permean=mean(this.min_angle_per);
            min_angle_perstd=std(this.min_angle_per);
            for i=1:this.Number_period + 1
                if (this.max_angle_per(i,1)>(max_angle_permean(1,1) + 3 * max_angle_perstd(1,1))) || (this.max_angle_per(i,1)<(max_angle_permean(1,1)-3*max_angle_perstd(1,1)))
                    this.max_angle_per(i,1)=max_angle_permean(1,1);
                end
                if (this.min_angle_per(i,1)>(min_angle_permean(1,1) + 3 * min_angle_perstd(1,1))) || (this.min_angle_per(i,1)<(min_angle_permean(1,1)-3*min_angle_perstd(1,1)))
                    this.min_angle_per(i,1)=min_angle_permean(1,1);
                end
            end

            % 平滑 torque
            this.max_torque_per(:,1)=smoothdata(this.max_torque_per(:,1), 'movmedian');
            this.min_torque_per(:,1)=smoothdata(this.min_torque_per(:,1), 'movmedian');

            this.theta_8 = (this.max_angle_per(100,1) - this.min_angle_per(100,1))/2;
            this.torque_8= (this.max_torque_per(100,1) - this.min_torque_per(100,1))/2;

            %扭矩转为应力
            D = 2 * this.sradius_ * 10^(-3);
            Len = this.slength_ * 10^(-3);
            Wp=((D^3)*pi)/16;

            this.max_Shearforceper = zeros(size(this.max_torque_per));
            this.max_Shearforceper(:, 1) = 10^(-6) * this.max_torque_per(:, 1)/Wp;
            this.max_Shearforceper(:, 2) = this.max_torque_per(:, 2);
            this.min_Shearforceper(:, 1) = 10^(-6) * this.min_torque_per(:, 1)/Wp;
            this.min_Shearforceper(:, 2) = this.min_torque_per(:, 2);
            this.mean_Shearforceper(:, 1) = 0.5 * (this.max_Shearforceper(:, 1) + this.min_Shearforceper(:, 1));
            this.mean_Shearforceper(:, 2) = this.min_torque_per(:, 2);

            %寻找断点
            bpointmaxtirx = this.max_Shearforceper(this.max_Shearforceper(:,1) - 0.7 * this.max_Shearforceper(1,1) < 2, :);
            this.bpoint=bpointmaxtirx(1,2);

            %角度转为应变
            this.max_Shearstrainper(:,1) = 0.5*D * this.max_angle_per(:,1)/Len;
            this.max_Shearstrainper(:,2) = this.max_angle_per(:,2);
            this.min_Shearstrainper(:,1) = 0.5*D * this.min_angle_per(:,1)/Len;
            this.min_Shearstrainper(:,2) = this.min_angle_per(:,2);
            this.mean_Shearstrainper(:,1)= 0.5*(this.max_Shearstrainper(:,1) + this.min_Shearstrainper(:,1));
            this.mean_Shearstrainper(:,2)= this.min_angle_per(:,2);

            % 平滑应力
            this.max_Shearforceperimproved = smoothdata(this.max_Shearforceper(:,1),'movmedian');
            this.min_Shearforceperimproved = smoothdata(this.min_Shearforceper(:,1),'movmedian');
            
            this.TauMaxMPa = max(this.max_Shearforceperimproved);
            this.TauMinMPa = min(this.min_Shearforceperimproved);
            this.TauMeanMPa = mean(this.mean_Shearforceper(:,1));
            this.Strain_TotMax = max(this.max_Shearstrainper(:,1));
            this.Strain_TotMin_ = min(this.min_Shearstrainper(:,1));
            this.Strain_TotMean = mean(this.mean_Shearstrainper(:,1));
            this.StrainRate = 2 * this.sampling_frequency * (this.Strain_TotMax - this.Strain_TotMin_);

            %环
            this.Shearforce  = 10^(-6) * Torque(:,1)/Wp;
            this.Shearstrain = 0.5 * D * Angle(:,1)/Len;

            plot_original_(this, this.max_angle_per, this.min_angle_per, ...,
                            this.max_torque_per, this.min_torque_per);
        end % process_rawdata_

        function plot_original_(this, A, B, type)
            figure           
            plot(A(:,2), A(:,1), [type 'b']);
            hold on;
            plot(B(:,2), B(:,1), [type 'r']);
        end % plot_original_

    end % private methods
end %classdef
