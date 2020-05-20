classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}
    end % public properties

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
            
            [path, ftype, rawtable] = get_path_by_eid_(this, eid);            
            [Angle, Torque] = read_raw_data_(this, path, ftype);
            this.len = length(Torque);

            insert_to_rawdata_table(this, eid, rawtable, Angle, Torque);          
            
            close(this.conn_);
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
    end % private methods
end %classdef
