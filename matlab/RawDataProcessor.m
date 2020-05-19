classdef RawDataProcessor
    properties (Access=public)
        len {mustBeNumeric}
        frequncy=0.1;
        sampling = 16;
        sradius = 3;
        slength = 20;
        
        datasource = 'cloudlab';
        username = 'cloudlab';
        passwd = 'CloudLab-!@#$';
        conn;
    end %properties
    
    methods (Access=public)
        
        function obj = raw_data_by_param(this, path, ftype, eid)
            [Ts, Angle, Torque] = read_raw_data(this, path, ftype);
            insert_to_db(this, Ts, Angle, Torque);
            this.len = length(Torque);
        end % raw_data

        function obj = raw_data_from_db_by_eid(this, eid)
            conn = database(this.datasource, this.username, this.passwd)

            [Ts, Angle, Torque] = read_raw_data(this, path, ftype);
            insert_to_db(this, Ts, Angle, Torque);
            this.len = length(Torque);
            close(conn);
        end % raw_data

        function obj = raw_data(this, eid)
            conn = database(this.datasource, this.username, this.passwd)

            [Ts, Angle, Torque] = read_raw_data(this, path, ftype);
            insert_to_db(this, Ts, Angle, Torque);
            this.len = length(Torque);
            close(conn);
        end % raw_data


        function [Ts, Angle, Torque] = read_raw_data(this, path, ftype)
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
                    Ts=[Ts;data1];
                    Angle=[Angle;data2];
                    Torque=[Torque;data6];
                else
                    [data1,data2,data3]=textread(file_name{i}, ...,
                        '%f%f%f','headerlines',1);
                    Ts=[Ts;data1];
                    Torque=[Torque;data2];
                    Angle=[Angle;data3];
                end %if
            end % for
        end % function read_raw_data
        
        function good = insert_to_db(this, Ts, Angle, Torque)
        end
    end % methods
end %classdef
