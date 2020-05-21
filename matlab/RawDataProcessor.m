classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}

        Number_period;
        sf % sampling_frequency;
        max_angle_per;
        min_angle_per;

        max_torque_per;
        min_torque_per;
        theta_8;
        torque_8;

        max_shearforce_per;
        min_shearforce_per;
        mean_shearforce_per;
        bpoint;

        max_shearstrain_per;
        min_shearstrain_per;
        mean_shearstrain_per;

        TauMaxMPa;
        TauMinMPa;
        TauMeanMPa;
        Strain_TotMax;
        Strain_TotMin_;
        Strain_TotMean;
        StrainRate;

        max_shearforce_perimproved;
        min_shearforce_perimproved;
        
        Shearforce;
        Shearstrain;
        
        ename;
    end %public properties
    
    properties (Access=private)
        frequency_ =0.1;
        sampling_ = 16;
        radius_ = 3;
        length_ = 20;

        datasource_ = 'cloudlab';
        username_ = 'cloudlab';
        passwd_ = 'CloudLab-!@#$';
        conn_;
    end %private properties

    methods (Access=public)        
        function self = raw_data_by_param(self, path, ftype)
            [Angle, Torque] = read_raw_data_(self, path, ftype);
            self.len = length(Torque);
            self = process_rawdata_(self, Angle, Torque);
            self =  force_strain_(self);
        end % raw_data

        function self = raw_data_from_db_by_eid(self, eid)
            self = init_(self);
            self.conn_ = database(self.datasource_, self.username_, ...,
                self.passwd_);
            
            [path, ftype, self.ename] = get_path_by_eid_(self, eid);
            [Angle, Torque] = read_raw_data_(self, path, ftype);
            close(self.conn_);

            self.len = length(Torque);
            self = process_rawdata_(self, Angle, Torque);
            self = force_strain_(self, Angle, Torque);
            plot_loops_(self);
            plot_specified_loop_(self);
        end % raw_data

        function self = raw_data(self)
            self.conn_ = database(self.datasource_, self.username_, ...,
                self.passwd_);

            eid = get_all_eid_(self);
            for i = 1 : length(eid)
                fprintf("Experiment %d ... ", i);
                [path, ftype, self.ename] = get_path_by_eid_(self, eid(i));
                [Angle, Torque] = read_raw_data_(self, path, ftype);
                fprintf("Length is %d ... ", length(Torque));
                % insert_to_rawdata_table(self, eid(i), rawtable, Angle, Torque);
                fprintf("Done.\n");
            end
            
            close(self.conn_);
        end % raw_data
    end % public methods

    methods (Access=private)
        function [Angle, Torque] = read_raw_data_(self, path, ftype)
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

        function [path, ftype, ename] = get_path_by_eid_(self, eid)
            sql = ['SELECT `ename`, `datapath`, `datatype` FROM `experiment` WHERE `eid` = ', ... ,
                int2str(eid)];
            res = fetch(self.conn_, sql);
            path = char(res.datapath(1));
            ftype = res.datatype(1);
            ename = char(res.ename(1));
        end

        function eid = get_all_eid_(self)
            sql = 'SELECT `eid` FROM `experiment`';
            res = fetch(self.conn_, sql);
            eid = res.eid;
        end %get_all_eid_
        
        function self = process_rawdata_(self, Angle, Torque)
            Angle = Angle * pi / 180;
            self.sf = self.sampling_/self.frequency_;
            
            %处理Theta, Torque
            Num=length(Angle);
            self.Number_period = 0;
            for period = 1:Num
                if period * self.sf <= Num
                    self.max_angle_per(period,1)=max(Angle((period-1) * self.sf + 1:period * self.sf));
                    self.max_angle_per(period,2)=period;

                    self.min_angle_per(period,1)=min(Angle((period-1) * self.sf + 1:period * self.sf));
                    self.min_angle_per(period,2)=period;

                    self.max_torque_per(period,1)=max(Torque((period-1) * self.sf + 1:period * self.sf));
                    self.max_torque_per(period,2)=period;

                    self.min_torque_per(period,1)=min(Torque((period-1) * self.sf + 1:period * self.sf));
                    self.min_torque_per(period,2)=period;

                    self.Number_period = period;
                    period = period + 1;
                else
                    self.max_angle_per(period,1)=max(Angle((period-1) * self.sf + 1:Num));
                    self.max_angle_per(period,2)=period;

                    self.min_angle_per(period,1)=min(Angle((period-1) * self.sf + 1:Num));
                    self.min_angle_per(period,2)=period;

                    self.max_torque_per(period,1)=max(Torque((period-1) * self.sf + 1:Num));
                    self.max_torque_per(period,2)=period;

                    self.min_torque_per(period,1)=min(Torque((period-1) * self.sf + 1:Num));
                    self.min_torque_per(period,2)=period;
                    break;
                end
            end
        
            self.theta_8 = (self.max_angle_per(100,1) - self.min_angle_per(100,1))/2;
            self.torque_8= (self.max_torque_per(100,1) - self.min_torque_per(100,1))/2;

            plot_original_(self, self.max_angle_per, self.min_angle_per, 'o');
            
            %去除坏点
            max_angle_per_mean=mean(self.max_angle_per);
            max_angle_per_std=std(self.max_angle_per);
            min_angle_per_mean=mean(self.min_angle_per);
            min_angle_per_std=std(self.min_angle_per);
            for i=1:self.Number_period+1
                if (self.max_angle_per(i,1)>(max_angle_per_mean(1,1)+3*max_angle_per_std(1,1)))||(self.max_angle_per(i,1)<(max_angle_per_mean(1,1)+3*max_angle_per_std(1,1)))
                    self.max_angle_per(i,1)=max_angle_per_mean(1,1);
                end
                if (self.min_angle_per(i,1)>(min_angle_per_mean(1,1)+3*min_angle_per_std(1,1)))||(self.min_angle_per(i,1)<(min_angle_per_mean(1,1)+3*min_angle_per_std(1,1)))
                    self.min_angle_per(i,1)=min_angle_per_mean(1,1);
                end
            end
           
            plot_original_(self, self.max_angle_per, self.min_angle_per, 'o');

            % Torque 对中操作
            move_distance = 0.5 * (self.max_torque_per(:,1) - self.min_torque_per(:,1)) - self.max_torque_per(:,1);
            self.max_torque_per(:,1) = self.max_torque_per(:,1) + move_distance(:,1);
            self.min_torque_per(:,1) = self.min_torque_per(:,1) + move_distance(:,1);
            
            plot_original_(self, self.max_torque_per, self.min_torque_per, 'v');
            
            % 平滑 torque
            self.max_torque_per(:,1)=smoothdata(self.max_torque_per(:,1), 'movmedian');
            self.min_torque_per(:,1)=smoothdata(self.min_torque_per(:,1), 'movmedian');
            
            plot_original_(self, self.max_torque_per, self.min_torque_per, 'v');
        end % process_rawdata_

        function self = force_strain_(self, Angle, Torque)
            %扭矩转为应力
            self.radius_ = self.radius_ * 10^(-3);
            self.length_ = self.length_ * 10^(-3);
            Wp=(((2 * self.radius_) ^3) * pi) / self.sampling_;

            self.max_shearforce_per = zeros(size(self.max_torque_per));
            self.min_shearforce_per = zeros(size(self.max_torque_per));
            self.mean_shearforce_per = zeros(size(self.max_torque_per));
            self.max_shearforce_per(:, 1) = 10^(-6) * self.max_torque_per(:, 1)/Wp;
            self.max_shearforce_per(:, 2) = self.max_torque_per(:, 2);
            self.min_shearforce_per(:, 1) = 10^(-6) * self.min_torque_per(:, 1)/Wp;
            self.min_shearforce_per(:, 2) = self.min_torque_per(:, 2);
            self.mean_shearforce_per(:, 1) = 0.5 * (self.max_shearforce_per(:, 1) + self.min_shearforce_per(:, 1));
            self.mean_shearforce_per(:, 2) = self.min_torque_per(:, 2);

            %寻找断点
            self.bpoint = 0;
            % bpointmaxtirx = self.max_shearforce_per(self.max_shearforce_per(:,1) - 0.7 * self.max_shearforce_per(1,1) < 2, :);
            % s = size(bpointmaxtirx);
            % if s(1) == 0
            %     self.bpoint = self.Number_period;
            % else
            %     self.bpoint = bpointmaxtirx(1,2);
            % end
            self.bpoint = self.Number_period;
            
            % remove the recordes after break point
            self.max_shearforce_per([self.bpoint : self.Number_period + 1], : ) = [];
            self.min_shearforce_per([self.bpoint : self.Number_period + 1], : ) = [];
            self.mean_shearforce_per([self.bpoint : self.Number_period + 1], : ) =[];

            %角度转为应变
            self.max_shearstrain_per = zeros(size(self.max_angle_per));
            self.min_shearstrain_per = zeros(size(self.max_angle_per));
            self.mean_shearstrain_per = zeros(size(self.max_angle_per));
            self.max_shearstrain_per(:,1) = self.radius_ * self.max_angle_per(:,1)/self.length_;
            self.max_shearstrain_per(:,2) = self.max_angle_per(:,2);
            self.min_shearstrain_per(:,1) = self.radius_ * self.min_angle_per(:,1)/self.length_;
            self.min_shearstrain_per(:,2) = self.min_angle_per(:,2);
            self.mean_shearstrain_per(:,1)= 0.5*(self.max_shearstrain_per(:,1) + self.min_shearstrain_per(:,1));
            self.mean_shearstrain_per(:,2)= self.min_angle_per(:,2);
            
            % remove the recordes after break point
            self.max_shearstrain_per([self.bpoint : self.Number_period + 1], : ) = [];
            self.min_shearstrain_per([self.bpoint : self.Number_period + 1], : ) = [];
            self.mean_shearstrain_per([self.bpoint : self.Number_period + 1], : ) = [];

            % 平滑应力
            self.max_shearforce_perimproved = smoothdata(self.max_shearforce_per(:,1),'movmedian');
            self.min_shearforce_perimproved = smoothdata(self.min_shearforce_per(:,1),'movmedian');
            
            self.TauMaxMPa = max(self.max_shearforce_perimproved);
            self.TauMinMPa = min(self.min_shearforce_perimproved);
            self.TauMeanMPa = mean(self.mean_shearforce_per(:,1));
            self.Strain_TotMax = max(self.max_shearstrain_per(:,1));
            self.Strain_TotMin_ = min(self.min_shearstrain_per(:,1));
            self.Strain_TotMean = mean(self.mean_shearstrain_per(:,1));
            self.StrainRate = 2 * self.sf * (self.Strain_TotMax - self.Strain_TotMin_);

            %环
            self.Shearforce  = 10^(-6) * Torque(:,1)/Wp;
            self.Shearstrain = self.radius_ * Angle(:,1)/self.length_;
        end % process_rawdata_

        function plot_original_(self, A, B, type)
            figure
            plot(A(:,2), A(:,1), [type 'b']);
            hold on;
            plot(B(:,2), B(:,1), [type 'r']);
        end % plot_original_

        function plot_loops_(self)
            figure
            for period=1:self.Number_period
                plot(self.Shearstrain((period-1)*self.sf + 1:period * self.sf),self.Shearforce((period-1)*self.sf+1:period*self.sf));
                hold on;
            end
            xlabel('\epsilon');
            ylabel('\sigma/MPa');
            title('Hysteresis Loops');
        end
        
        function plot_specified_loop_(self)
            plot_single_loop__(self, 1);
            plot_single_loop__(self, self.bpoint - 1);
            plot_single_loop__(self, self.bpoint);
        end % plot_specified_loop_
        
        function plot_single_loop__(self, period)
            figure
            plot(self.Shearstrain((period-1) * self.sf + 1 : period * self.sf), self.Shearforce((period-1) * self.sf + 1 : period * self.sf));
            xlabel('\epsilon');
            ylabel('\sigma/MPa');
            title(['Specified Hysteresis Loops' int2str(period)]);
        end % plot_single_loop__
        
        function self = init_(self)
            self.len = [];

            self.Number_period = [];
            self.sf  = []; % sampling_frequency;
            self.max_angle_per = [];
            self.min_angle_per = [];

            self.max_torque_per = [];
            self.min_torque_per = [];
            self.theta_8 = [];
            self.torque_8 = [];

            self.max_shearforce_per = [];
            self.min_shearforce_per = [];
            self.mean_shearforce_per = [];
            self.bpoint = [];

            self.max_shearstrain_per = [];
            self.min_shearstrain_per = [];
            self.mean_shearstrain_per = [];

            self.TauMaxMPa = [];
            self.TauMinMPa = [];
            self.TauMeanMPa = [];
            self.Strain_TotMax = [];
            self.Strain_TotMin_ = [];
            self.Strain_TotMean = [];
            self.StrainRate = [];

            self.max_shearforce_perimproved = [];
            self.min_shearforce_perimproved = [];

            self.Shearforce = [];
            self.Shearstrain = [];
        end % init_
        
    end % private methods
end %classdef
