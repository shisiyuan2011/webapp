classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}
    end % public properties

    properties (Access=private)
        frequncy_ =0.1;
        sampling_ = 16;
        sradius_ = 3;
        slength_ = 20;

        Number_period_;
        sampling_frequency_;
        max_angle_per_;
        min_angle_per_;

        max_torque_per_;
        min_torque_per_;
        theta_8_;
        torque_8_;

        max_shearforce_per_;
        min_shearforce_per_;
        mean_shearforce_per_;
        bpoint_;

        max_shearstrain_per_;
        min_shearstrain_per_;
        mean_shearstrain_per_;

        TauMaxMPa_;
        TauMinMPa_;
        TauMeanMPa_;
        Strain_TotMax_;
        Strain_TotMin_;
        Strain_TotMean_;
        StrainRate_;

        max_shearforce_per_improved_;
        min_shearforce_per_improved_;
        
        Shearforce_;
        Shearstrain_;

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
            
            [path, ftype, rawtable] = get_path_by_eid_(this, eid);            
            [Angle, Torque] = read_raw_data_(this, path, ftype);
            close(this.conn_);

            this.len = length(Torque);

            process_rawdata_(this, Angle, Torque);
        end % raw_data

        function this = raw_data(this)
            this.conn_ = database(this.datasource_, this.username_, ...,
                this.passwd_);

            eid = get_all_eid_(this);
            for i = 1 : length(eid)
                fprintf("Experiment %d ... ", i);
                [path, ftype, rawtable] = get_path_by_eid_(this, eid(i));
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

            Ts=[];
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
            this.sampling_frequency_ = this.sampling_/this.frequncy_;
            
            %处理Theta, Torque
            Num=length(Angle);
            this.Number_period_ = 0;
            for period = 1:Num
                if period * this.sampling_frequency_ <= Num
                    this.max_angle_per_(period,1)=max(Angle((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.max_angle_per_(period,2)=period;

                    this.min_angle_per_(period,1)=min(Angle((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.min_angle_per_(period,2)=period;

                    this.max_torque_per_(period,1)=max(Torque((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.max_torque_per_(period,2)=period;

                    this.min_torque_per_(period,1)=min(Torque((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.min_torque_per_(period,2)=period;

                    this.Number_period_ = period;
                else
                    this.max_angle_per_(period,1)=max(Angle((period-1) * this.sampling_frequency_ + 1:Num));
                    this.max_angle_per_(period,2)=period;

                    this.min_angle_per_(period,1)=min(Angle((period-1) * this.sampling_frequency_ + 1:Num));
                    this.min_angle_per_(period,2)=period;

                    this.max_torque_per_(period,1)=max(Torque((period-1) * this.sampling_frequency_ + 1:Num));
                    this.max_torque_per_(period,2)=period;

                    this.min_torque_per_(period,1)=min(Torque((period-1) * this.sampling_frequency_ + 1:Num));
                    this.min_torque_per_(period,2)=period;
                    break;
                end
            end

            %去除坏点 Angle
            max_angle_per_mean=mean(this.max_angle_per_);
            max_angle_per_std=std(this.max_angle_per_);
            min_angle_per_mean=mean(this.min_angle_per_);
            min_angle_per_std=std(this.min_angle_per_);
            for i=1:this.Number_period_ + 1
                if (this.max_angle_per_(i,1)>(max_angle_per_mean(1,1) + 3 * max_angle_per_std(1,1))) || (this.max_angle_per_(i,1)<(max_angle_per_mean(1,1)-3*max_angle_per_std(1,1)))
                    this.max_angle_per_(i,1) = max_angle_per_mean(1,1);
                end
                if (this.min_angle_per_(i,1)>(min_angle_per_mean(1,1) + 3 * min_angle_per_std(1,1))) || (this.min_angle_per_(i,1)<(min_angle_per_mean(1,1)-3*min_angle_per_std(1,1)))
                    this.min_angle_per_(i,1) = min_angle_per_mean(1,1);
                end
            end

            % Torque 对中操作
            move_distance = 0.5 * (this.max_torque_per_(:,1) - this.min_torque_per_(:,1)) - this.max_torque_per_(:,1);
            this.max_torque_per_(:,1) = this.max_torque_per_(:,1) + move_distance(:,1);
            this.min_torque_per_(:,1) = this.min_torque_per_(:,1) + move_distance(:,1);


            plot_original_(this, this.max_angle_per_, this.min_angle_per_, ...,
                            this.max_torque_per_, this.min_torque_per_);
        end % process_rawdata_

        function this = process_rawdata_1_(this, Angle, Torque)
            Angle = Angle * pi / 180;
            this.sampling_frequency_ = this.sampling_/this.frequncy_;
            
            %处理Theta, Torque
            Num=length(Angle);
            this.Number_period_ = 0;
            for period = 1:Num
                if period * this.sampling_frequency_ <= Num
                    this.max_angle_per_(period,1)=max(Angle((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.max_angle_per_(period,2)=period;

                    this.min_angle_per_(period,1)=min(Angle((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.min_angle_per_(period,2)=period;

                    this.max_torque_per_(period,1)=max(Torque((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.max_torque_per_(period,2)=period;

                    this.min_torque_per_(period,1)=min(Torque((period-1) * this.sampling_frequency_ + 1:period * this.sampling_frequency_));
                    this.min_torque_per_(period,2)=period;

                    this.Number_period_ = period;
                    period = period + 1;
                else
                    this.max_angle_per_(period,1)=max(Angle((period-1) * this.sampling_frequency_ + 1:Num));
                    this.max_angle_per_(period,2)=period;

                    this.min_angle_per_(period,1)=min(Angle((period-1) * this.sampling_frequency_ + 1:Num));
                    this.min_angle_per_(period,2)=period;

                    this.max_torque_per_(period,1)=max(Torque((period-1) * this.sampling_frequency_ + 1:Num));
                    this.max_torque_per_(period,2)=period;

                    this.min_torque_per_(period,1)=min(Torque((period-1) * this.sampling_frequency_ + 1:Num));
                    this.min_torque_per_(period,2)=period;
                    break;
                end
            end

            % Torque 对中操作
            move_distance = 0.5 * (this.max_torque_per_ - this.min_torque_per_) - this.max_torque_per_;
            this.max_torque_per_ = this.max_torque_per_ + move_distance;
            this.min_torque_per_ = this.min_torque_per_ + move_distance;
            
            %去除坏点 Angle
            max_angle_per_mean=mean(this.max_angle_per_);
            max_angle_per_std=std(this.max_angle_per_);
            min_angle_per_mean=mean(this.min_angle_per_);
            min_angle_per_std=std(this.min_angle_per_);
            for i=1:this.Number_period_ + 1
                if (this.max_angle_per_(i,1)>(max_angle_per_mean(1,1) + 3 * max_angle_per_std(1,1))) || (this.max_angle_per_(i,1)<(max_angle_per_mean(1,1)-3*max_angle_per_std(1,1)))
                    this.max_angle_per_(i,1)=max_angle_per_mean(1,1);
                end
                if (this.min_angle_per_(i,1)>(min_angle_per_mean(1,1) + 3 * min_angle_per_std(1,1))) || (this.min_angle_per_(i,1)<(min_angle_per_mean(1,1)-3*min_angle_per_std(1,1)))
                    this.min_angle_per_(i,1)=min_angle_per_mean(1,1);
                end
            end

            % 平滑 torque
            this.max_torque_per_(:,1)=smoothdata(this.max_torque_per_(:,1), 'movmedian');
            this.min_torque_per_(:,1)=smoothdata(this.min_torque_per_(:,1), 'movmedian');

            this.theta_8_ = (this.max_angle_per_(100,1) - this.min_angle_per_(100,1))/2;
            this.torque_8_= (this.max_torque_per_(100,1) - this.min_torque_per_(100,1))/2;

            %扭矩转为应力
            D = 2 * this.sradius_ * 10^(-3);
            Len = this.slength_ * 10^(-3);
            Wp=((D^3)*pi)/16;

            this.max_shearforce_per_ = zeros(size(this.max_torque_per_));
            this.max_shearforce_per_(:, 1) = 10^(-6) * this.max_torque_per_(:, 1)/Wp;
            this.max_shearforce_per_(:, 2) = this.max_torque_per_(:, 2);
            this.min_shearforce_per_(:, 1) = 10^(-6) * this.min_torque_per_(:, 1)/Wp;
            this.min_shearforce_per_(:, 2) = this.min_torque_per_(:, 2);
            this.mean_shearforce_per_(:, 1) = 0.5 * (this.max_shearforce_per_(:, 1) + this.min_shearforce_per_(:, 1));
            this.mean_shearforce_per_(:, 2) = this.min_torque_per_(:, 2);

            %寻找断点
            bpoint_maxtirx = this.max_shearforce_per_(this.max_shearforce_per_(:,1) - 0.7 * this.max_shearforce_per_(1,1) < 2, :);
            this.bpoint_=bpoint_maxtirx(1,2);

            %角度转为应变
            this.max_shearstrain_per_(:,1) = 0.5*D * this.max_angle_per_(:,1)/Len;
            this.max_shearstrain_per_(:,2) = this.max_angle_per_(:,2);
            this.min_shearstrain_per_(:,1) = 0.5*D * this.min_angle_per_(:,1)/Len;
            this.min_shearstrain_per_(:,2) = this.min_angle_per_(:,2);
            this.mean_shearstrain_per_(:,1)= 0.5*(this.max_shearstrain_per_(:,1) + this.min_shearstrain_per_(:,1));
            this.mean_shearstrain_per_(:,2)= this.min_angle_per_(:,2);

            % 平滑应力
            this.max_shearforce_per_improved_ = smoothdata(this.max_shearforce_per_(:,1),'movmedian');
            this.min_shearforce_per_improved_ = smoothdata(this.min_shearforce_per_(:,1),'movmedian');
            
            this.TauMaxMPa_ = max(this.max_shearforce_per_improved_);
            this.TauMinMPa_ = min(this.min_shearforce_per_improved_);
            this.TauMeanMPa_ = mean(this.mean_shearforce_per_(:,1));
            this.Strain_TotMax_ = max(this.max_shearstrain_per_(:,1));
            this.Strain_TotMin_ = min(this.min_shearstrain_per_(:,1));
            this.Strain_TotMean_ = mean(this.mean_shearstrain_per_(:,1));
            this.StrainRate_ = 2 * this.sampling_frequency_ * (this.Strain_TotMax_ - this.Strain_TotMin_);

            %环
            this.Shearforce_  = 10^(-6) * Torque(:,1)/Wp;
            this.Shearstrain_ = 0.5 * D * Angle(:,1)/Len;

            plot_original_(this, this.max_angle_per_, this.min_angle_per_, ...,
                            this.max_torque_per_, this.min_torque_per_);
        end % process_rawdata_

        function this = plot_original_(this, max_angle_per, min_angle_per, max_torque_per, min_torque_per)
            figure
            
            % plot(max_angle_per(:,2), max_angle_per(:,1),'ob');
            % hold on;
            % plot(min_angle_per(:,2), min_angle_per(:,1),'or');
            % hold on;
            plot(max_torque_per(:,2),max_torque_per(:,1),'vb');
            hold on;
            plot(min_torque_per(:,2),min_torque_per(:,1),'vr');
        end % plot_original_

    end % private methods
end %classdef
