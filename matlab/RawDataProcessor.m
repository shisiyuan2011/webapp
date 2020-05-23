classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}

        Number_period;
        sf % sampling_frequency;
        bpoint;

        max_angle;
        min_angle;

        max_torque;
        min_torque;
        theta_8;
        torque_8;

        max_shearforce;
        min_shearforce;
        max_shearstrain;
        min_shearstrain;

        max_shearforce_improved;
        min_shearforce_per_improved;

        TauMaxMPa;
        TauMinMPa;
        TauMeanMPa;
        Strain_TotMax;
        Strain_TotMin_;
        Strain_TotMean;
        StrainRate;

        G_right;
        G_left;
        G_mean;
        Tao_max;

        G_left_value;
        G_right_alue;
        nHardening;
        KMPa;
        Strain_Plastic;
        Strain_Elastic;
        Strain_amplitude;
        Tau_MaxMPa;
        Tau_amplitudeMPa;
        strain_total;
        g_mean_mean;
        tau_max_mean;
        
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
            self.conn_ = database(self.datasource_, self.username_, ...,
                self.passwd_);
            self = raw_data_from_db_by_eid_(self, eid);
            close(self.conn_);
        end % raw_data_from_db_by_eid

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
        function self = raw_data_from_db_by_eid_(self, eid)
            self = init_(self);
            
            [path, ftype, self.ename] = get_path_by_eid_(self, eid);
            [Angle, Torque] = read_raw_data_(self, path, ftype);

            self.len = length(Torque);
            self = process_rawdata_(self, Angle, Torque);
            self = force_strain_(self, Angle, Torque);
            self = plot_loops_(self, Torque, Angle);
        end % raw_data

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
            Angle = Angle * pi / 180;
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
            self.sf = self.sampling_/self.frequency_;

            %处理Theta, Torque
            Num=length(Angle);
            self.Number_period = 0;
            for period = 1:Num
                if period * self.sf <= Num
                    self.max_angle(period,1)=max(Angle((period-1) * self.sf + 1:period * self.sf));
                    self.max_angle(period,2)=period;

                    self.min_angle(period,1)=min(Angle((period-1) * self.sf + 1:period * self.sf));
                    self.min_angle(period,2)=period;

                    self.max_torque(period,1)=max(Torque((period-1) * self.sf + 1:period * self.sf));
                    self.max_torque(period,2)=period;

                    self.min_torque(period,1)=min(Torque((period-1) * self.sf + 1:period * self.sf));
                    self.min_torque(period,2)=period;

                    self.Number_period = period;
                else
                    self.max_angle(period,1)=max(Angle((period-1) * self.sf + 1:Num));
                    self.max_angle(period,2)=period;

                    self.min_angle(period,1)=min(Angle((period-1) * self.sf + 1:Num));
                    self.min_angle(period,2)=period;

                    self.max_torque(period,1)=max(Torque((period-1) * self.sf + 1:Num));
                    self.max_torque(period,2)=period;

                    self.min_torque(period,1)=min(Torque((period-1) * self.sf + 1:Num));
                    self.min_torque(period,2)=period;
                    break;
                end
            end
        
            self.theta_8 = (self.max_angle(100,1) - self.min_angle(100,1))/2;
            self.torque_8= (self.max_torque(100,1) - self.min_torque(100,1))/2;

            plot_two_variable_(self, self.max_angle, self.min_angle, 'o');
            
            %去除坏点
            max_angle_per_mean=mean(self.max_angle);
            max_angle_per_std=std(self.max_angle);
            min_angle_per_mean=mean(self.min_angle);
            min_angle_per_std=std(self.min_angle);
            for i=1:self.Number_period+1
                if (self.max_angle(i,1)>(max_angle_per_mean(1,1)+3*max_angle_per_std(1,1)))||(self.max_angle(i,1)<(max_angle_per_mean(1,1)+3*max_angle_per_std(1,1)))
                    self.max_angle(i,1)=max_angle_per_mean(1,1);
                end
                if (self.min_angle(i,1)>(min_angle_per_mean(1,1)+3*min_angle_per_std(1,1)))||(self.min_angle(i,1)<(min_angle_per_mean(1,1)+3*min_angle_per_std(1,1)))
                    self.min_angle(i,1)=min_angle_per_mean(1,1);
                end
            end
           
            plot_two_variable_(self, self.max_angle, self.min_angle, 'o');

            % Torque 对中操作
            move_distance = 0.5 * (self.max_torque(:,1) - self.min_torque(:,1)) - self.max_torque(:,1);
            self.max_torque(:,1) = self.max_torque(:,1) + move_distance(:,1);
            self.min_torque(:,1) = self.min_torque(:,1) + move_distance(:,1);
            
            plot_two_variable_(self, self.max_torque, self.min_torque, 'v');
            
            % 平滑 torque
            self.max_torque(:,1)=smoothdata(self.max_torque(:,1), 'movmedian');
            self.min_torque(:,1)=smoothdata(self.min_torque(:,1), 'movmedian');
            
            plot_two_variable_(self, self.max_torque, self.min_torque, 'v');           
        end % process_rawdata_

        function self = force_strain_(self, Angle, Torque)
            %扭矩转为应力
            self.radius_ = self.radius_ * 10^(-3);
            self.length_ = self.length_ * 10^(-3);
            Wp=(((2 * self.radius_)^3) * pi) / self.sampling_;

            self.max_shearforce = zeros(size(self.max_torque));
            self.min_shearforce = zeros(size(self.max_torque));
            mean_shearforce_per = zeros(size(self.max_torque));
            self.max_shearforce(:, 1) = (10^(-6) /Wp) * self.max_torque(:, 1);
            self.max_shearforce(:, 2) = self.max_torque(:, 2);
            self.min_shearforce(:, 1) = (10^(-6) /Wp) * self.min_torque(:, 1);
            self.min_shearforce(:, 2) = self.min_torque(:, 2);
            mean_shearforce_per(:, 1) = 0.5 * (self.max_shearforce(:, 1) + self.min_shearforce(:, 1));
            mean_shearforce_per(:, 2) = self.min_torque(:, 2);

            %寻找断点
            % bpointmaxtirx = self.max_shearforce(self.max_shearforce(:,1) - 0.7 * self.max_shearforce(1,1) < 2, :);
            % s = size(bpointmaxtirx);
            % if s(1) == 0
            %     self.bpoint = self.Number_period;
            % else
            %     self.bpoint = bpointmaxtirx(1,2);
            % end
            self.bpoint = self.Number_period;
            
            % remove the recordes after break point
            self.max_shearforce((self.bpoint : self.Number_period + 1), : ) = [];
            self.min_shearforce((self.bpoint : self.Number_period + 1), : ) = [];
            mean_shearforce_per((self.bpoint : self.Number_period + 1), : ) =[];

            %角度转为应变
            self.max_shearstrain = zeros(size(self.max_angle));
            self.min_shearstrain = zeros(size(self.max_angle));
            mean_shearstrain_per = zeros(size(self.max_angle));
            self.max_shearstrain(:,1) = (self.radius_ / self.length_) * self.max_angle(:,1);
            self.max_shearstrain(:,2) = self.max_angle(:,2);
            self.min_shearstrain(:,1) = (self.radius_ / self.length_) * self.min_angle(:,1);
            self.min_shearstrain(:,2) = self.min_angle(:,2);
            mean_shearstrain_per(:,1)= 0.5*(self.max_shearstrain(:,1) + self.min_shearstrain(:,1));
            mean_shearstrain_per(:,2)= self.min_angle(:,2);
            
            % remove the recordes after break point
            self.max_shearstrain([self.bpoint : self.Number_period + 1], : ) = [];
            self.min_shearstrain([self.bpoint : self.Number_period + 1], : ) = [];
            mean_shearstrain_per([self.bpoint : self.Number_period + 1], : ) = [];

            % 平滑应力
            self.max_shearforce_improved = smoothdata(self.max_shearforce(:,1),'movmedian');
            self.min_shearforce_per_improved = smoothdata(self.min_shearforce(:,1),'movmedian');
            
            self.TauMaxMPa = max(self.max_shearforce_improved);
            self.TauMinMPa = min(self.min_shearforce_per_improved);
            self.TauMeanMPa = mean(mean_shearforce_per(:,1));
            self.Strain_TotMax = max(self.max_shearstrain(:,1));
            self.Strain_TotMin_ = min(self.min_shearstrain(:,1));
            self.Strain_TotMean = mean(mean_shearstrain_per(:,1));
            self.StrainRate = 2 * self.sf * (self.Strain_TotMax - self.Strain_TotMin_);
            
            plot_two_lines_2_(self, self.max_shearforce, self.max_shearforce_improved);
            plot_two_lines_2_(self, self.min_shearforce, self.min_shearforce_per_improved);
            plot_two_lines_1_(self, self.max_shearstrain, self.min_shearstrain);
        end % process_rawdata_

        function plot_two_variable_(self, A, B, type)
            figure
            plot(A(:,2), A(:,1), [type 'b']);
            hold on;
            plot(B(:,2), B(:,1), [type 'r']);
        end % plot_two_variable_
        
        function plot_line_1_(self, A)
            figure
            plot(A(:,2), A(:,1));
        end % plot_two_line_1_

        function plot_line_2_(self, A, B)
            figure
            plot(A(:,2), B);
        end % plot_two_line_1_

        function plot_two_lines_2_(self, A, B)
            figure
            plot(A(:,2), A(:,1));
            hold on;
            plot(A(:,2), B);
        end % plot_two_lines_2_

        function plot_two_lines_1_(self, A, B)
            figure
            plot(A(:,2), A(:,1));
            hold on;
            plot(B(:,2), B(:,1));
        end % plot_two_lines_1_

        function self = plot_loops_(self, Torque, Angle)
            Wp=(((2 * self.radius_)^3) * pi) / self.sampling_;

            %环
            Shearforce  = 10^(-6) * Torque(:,1)/Wp;
            Shearstrain = self.radius_ * Angle(:,1)/self.length_;

            figure
            for period=1:self.Number_period
                plot(Shearstrain((period-1)*self.sf + 1:period * self.sf), Shearforce((period-1)*self.sf+1:period*self.sf));
                hold on;
            end
            xlabel('\epsilon');
            ylabel('\sigma/MPa');
            title('Hysteresis Loops');

            plot_single_loop__(self, 1, Shearstrain, Shearforce);
            plot_single_loop__(self, 100, Shearstrain, Shearforce);
            plot_single_loop__(self, self.bpoint - 1, Shearstrain, Shearforce);
            plot_single_loop__(self, self.bpoint, Shearstrain, Shearforce);
            
            self = strain_force_(self, 100, self.Number_period, Shearstrain, Shearforce);
        end % plot_loops_
                
        function plot_single_loop__(self, period, Shearstrain, Shearforce)
            figure
            plot(Shearstrain((period-1) * self.sf + 1 : period * self.sf), Shearforce((period-1) * self.sf + 1 : period * self.sf));
            xlabel('\epsilon');
            ylabel('\sigma/MPa');
            title(['Specified Hysteresis Loops' int2str(period)]);
        end % plot_single_loop__
        
        function self = init_(self)
            self.len = [];

            self.Number_period = [];
            self.sf  = []; % sampling_frequency;
            self.bpoint = [];

            self.max_angle = [];
            self.min_angle = [];

            self.max_torque = [];
            self.min_torque = [];
            self.theta_8 = [];
            self.torque_8 = [];

            self.max_shearforce = [];
            self.min_shearforce = [];
            self.max_shearstrain = [];
            self.min_shearstrain = [];
            self.max_shearforce_improved = [];
            self.min_shearforce_per_improved = [];

            self.TauMaxMPa = [];
            self.TauMinMPa = [];
            self.TauMeanMPa = [];
            self.Strain_TotMax = [];
            self.Strain_TotMin_ = [];
            self.Strain_TotMean = [];
            self.StrainRate = [];
            
            self.G_right = [];
            self.G_left = [];
            self.G_mean = [];
            self.Tao_max = [];
            
            self.G_left_value=[];
            self.G_right_alue=[];
            self.nHardening=[];
            self.KMPa=[];
            self.Strain_Plastic=[];
            self.Strain_Elastic=[];
            self.Strain_amplitude=[];
            self.Tau_MaxMPa=[];
            self.Tau_amplitudeMPa=[];

            self.strain_total = [];
            self.g_mean_mean = [];
            self.tau_max_mean = [];

            self.frequency_ =0.1;
            self.sampling_ = 16;
            self.radius_ = 3;
            self.length_ = 20;
        end % init_

        function self = strain_force_(self, loop_id, end_loop, Shearstrain, Shearforce)
            [self.Strain_Plastic, self.Strain_Elastic, self.Strain_amplitude, self.Tau_MaxMPa, self.Tau_amplitudeMPa, gright, gleft, ~, self.KMPa,self.nHardening] = HystLoop_DH(Shearstrain, Shearforce, loop_id);
            self.G_left_value=gleft/1000;
            self.G_right_alue=gright/1000;

            [~,~,self.Strain_amplitude,~,self.Tau_amplitudeMPa,~,~,~,~,~] = HystLoop_DH(Shearstrain,Shearforce,1);

            [self.Tao_max,self.G_right,self.G_left,self.G_mean,~] = G_Tau_N(Shearstrain, Shearforce, end_loop);
            self.strain_total = max(self.max_shearstrain(:,1)) - min(self.min_shearstrain(:,1));
            self.g_mean_mean = mean(self.G_mean);
            self.tau_max_mean = max(self.max_shearforce_improved);
            
            figure
            semilogx((1 : end_loop) * 0.001, self.G_mean, '-o');

            figure
            semilogx((1 : end_loop) * 0.001, self.Tao_max, '-o');
        end % strain_force_
    end % private methods
end %classdef
