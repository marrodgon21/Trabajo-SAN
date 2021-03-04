function [GPRMC,GPGGA,GPVTG,GPGSA] = HelperParseGPSData(inData)

% Parse NMEA data for RMC,GGA,VTG and GGA sentences. The parser is capable
% of parsing for "GPRMC", "GPGGA","GPVTG" and "GPGSA" sentences. The NMEA
% sentences are assumed to be in accordance with NMEA version 2.3.
%
% [GPRMC,GPGGA,GPVTG,GPGSA] = HelperParseGPSData(inData), parses the inData for
% NMEA sentences corresponding to message IDs RMC, GGA, VTG and GSA.Each
% NMEA sentences in the input are expected to be seperated by Carriage
% return (ascii of 13).The function returns structure for each message ID
% whose fields corresponds to the data decoded from the corresponding
% sentence. Each structure has a field name ChecksumValidity which says if
% the received data is valid determined by calculating the checksum.
%
% If the input data does not have the NMEA sentence correspoding to the
% message ID.The structure corresponding to that message ID returns empty
% feild except for the messageID feild in the structure.These outputs can
% be suppressed using tilde(~) operator. For example:
%
% GPSData =
% '$GPGGA,135015.00,1257.62410,N,07742.00316,E,1,06,1.56,903.3,M,-86.4,M,,*77';
% [~,GPGGA,~,~] = HelperParseGPSData(GPSData);
%
%
inData = char(inData);

endChar = 13;
seperator = ',';
degree_symbol = char(176);

% check if message ID corresponding to RMC is available and extract RMC
% sentence.
try
    [dataRMCUnparsed,NoOfRMCmsgs,status] = preprocessGPSData(inData,'GPRMC', endChar);
catch ME
    throwAsCaller(ME)
end
GPRMC = struct('MessageID','RMC','Status','','DateandTime','','Latitude','','Longitude','','SOG','','COG','','MagneticVariation','','Mode','','Checksum','','ChecksumValidity','');
if(status == 1)
    % If message ID is found
    rmc_idx = 1;
    while(rmc_idx<=NoOfRMCmsgs)
        try
            GPRMC(rmc_idx) = parseRMC(dataRMCUnparsed{rmc_idx});
        catch ME
            throwAsCaller(ME)
        end
        rmc_idx=rmc_idx+1;
    end
end

% check if message ID corresponding to GGA is available and extract GGA
% sentence.
try
    [dataGGAUnparsed,NoOfGGAmsgs,status] = preprocessGPSData(inData,'GPGGA', endChar);
catch ME
    throwAsCaller(ME);
end
GPGGA= struct('MessageID','GGA','Time','','Latitude','','Longitude','','FixStatus','','NumSatelites','','HDOP','','Altitude','','HeightofGeoid','','DiffAge','','DGPSStationID','','Checksum','','ChecksumValidity','');
if(status == 1)
    gga_idx = 1;
    while(gga_idx<=NoOfGGAmsgs)
        try
            GPGGA(gga_idx) = parseGGA(dataGGAUnparsed{gga_idx});
        catch ME
            throwAsCaller(ME);
        end
        gga_idx=gga_idx+1;
    end
end

% check if message ID corresponding to VTG is available and extract VTG
% sentence.
try
    [dataVTGUnparsed,NoOfVTGmsgs,status] = preprocessGPSData(inData,'GPVTG', endChar);
catch ME
    throwAsCaller(ME)
end
GPVTG= struct('MessageID','VTG','TrueTrackMadeGood','','MagneticTrackMadeGood','','GroundSpeedinKnots','','GroundSpeedinKmph','','Mode','','Checksum','','ChecksumValidity','');
if(status == 1)
    vtg_idx = 1;
    while(vtg_idx<=NoOfVTGmsgs)
        try
            GPVTG(vtg_idx) = parseVTG(dataVTGUnparsed{vtg_idx});
        catch ME
            throwAsCaller(ME);
        end
        vtg_idx=vtg_idx+1;
    end
end
try
    [dataGSAUnparsed,NoOfGSAmsgs,status] = preprocessGPSData(inData,'GPGSA', endChar);
catch ME
    throwAsCaller(ME)
end
GPGSA= struct('MessageID','GSA','SelectionofFix','','FixType','','PRNs','','PDOP','','HDOP','','VDOP','','Checksum','','ChecksumValidity','');
if(status == 1)
    gsa_idx = 1;
    while(gsa_idx<=NoOfGSAmsgs)
        try
            GPGSA(gsa_idx) = parseGSA(dataGSAUnparsed{gsa_idx});
        catch ME
            throwAsCaller(ME);
        end
        gsa_idx=gsa_idx+1;
    end
end


% Function to parse RMC Sentences
    function GPRMC = parseRMC(dataRMCUnparsed)
        GPRMC= struct('MessageID','RMC','Status','','DateandTime','','Latitude','','Longitude','','SOG','','COG','','MagneticVariation','','Mode','','Checksum','','ChecksumValidity','');
        dataRMC = strsplit(dataRMCUnparsed,{seperator,'*'},'CollapseDelimiters',false);
        index=1;
        index = index+1;
        if(numel(dataRMC)>=13)
            % If fix or data is not available, GPS recievers output empty
            % feilds.
            if(~isempty(dataRMC{index}))
                Time = dataRMC{index};
                Time = char([Time(1:2),':',Time(3:4),':',Time(5:end)]);
            end
            index = index+1;
            if(~isempty(dataRMC{index}))
                Status = dataRMC{index};
                if(strcmp(Status,'A'))
                    GPRMC.Status = ['A',',Data Valid'];
                elseif (strcmp(Status,'V'))
                    GPRMC.Status = ['V',',Navigation Reciever warning'];
                else
                    GPRMC.Status = dataRMC{index};
                end
            end
            index = index+1;
            Latitude = dataRMC{index};
            index = index+1;
            LatitudeD = dataRMC{index};
            index = index+1;
            if(~isempty(Latitude)|| ~isempty(LatitudeD))
                GPRMC.Latitude = convertLatLong(Latitude,LatitudeD);
            end
            Longitude = dataRMC{index};
            index = index+1;
            LongitudeD = dataRMC{index};
            index = index+1;
            if(~isempty(Longitude) || ~isempty(LongitudeD))
                GPRMC.Longitude = convertLatLong(Longitude,LongitudeD);
            end
            if(~isempty(dataRMC{index}))
                GPRMC.SOG = [(dataRMC{index}),' knots'];
            end
            index = index+1;
            if(~isempty(dataRMC{index}))
                GPRMC.COG = [dataRMC{index},degree_symbol];
            end
            index = index+1;
            if(~isempty(dataRMC{index}))
                Date = dataRMC{index};
                Date = char([Date(1:2),'/',Date(3:4),'/',Date(5:end)]);
                GPRMC.DateandTime = [Time,' ',Date,' UTC'];
            end
            index = index+1;
            MagneticVariation = [dataRMC{index}];
            index = index+1;
            MagneticVariationD = dataRMC{index};
            index = index+1;
            if(~isempty(MagneticVariation) && ~isempty(MagneticVariationD))
                GPRMC.MagneticVariation=[MagneticVariation,degree_symbol,' ',MagneticVariationD];
            end
            if(numel(dataRMC)>13)
                % NMEA version >2.3, doesnt provide this feild.
                Mode = dataRMC{index};
                switch(Mode)
                    case 'N'
                        GPRMC.Mode = 'No Fix';
                    case 'A'
                        GPRMC.Mode = 'Autonomous GNSS Fix';
                    case 'D'
                        GPRMC.Mode = 'Differential GNSS Fix';
                    case 'E'
                        GPRMC.Mode = 'Estimated/Dead Reckoning Fix';
                    otherwise
                        GPRMC.Mode=dataRMC{index};
                end
            end
            RMC_ChecksumIdx = strfind(dataRMCUnparsed,'*');
            checksum = char(dataRMCUnparsed(RMC_ChecksumIdx+1:RMC_ChecksumIdx+2));
            GPRMC.Checksum=checksum;
            validity = validateData(dataRMCUnparsed,GPRMC.Checksum);
            GPRMC.ChecksumValidity = validity;
        else
            error('Invalid RMC sentence');
        end
    end

% Function to parse GGA Sentences
    function GPGGA= parseGGA(dataGGAUnparsed)
        GPGGA= struct('MessageID','GGA','Time','','Latitude','','Longitude','','FixStatus','','NumSatelites','','HDOP','','Altitude','','HeightofGeoid','','DiffAge','','DGPSStationID','','Checksum','','ChecksumValidity','');
        dataGGA = (strsplit(dataGGAUnparsed,{seperator,'*'},'CollapseDelimiters',false));
        index=1;
        index = index+1;
        % If fix or data is not available, GPS recievers output empty
        % feilds.
        if(numel(dataGGA)>=16)
            if(~isempty(dataGGA{index}))
                Time = dataGGA{index};
                GPGGA.Time = [char([Time(1:2),':',Time(3:4),':',Time(5:end)]), ' UTC'];
            end
            index = index+1;
            Latitude = dataGGA{index};
            index = index+1;
            LatitudeD = dataGGA{index};
            index = index+1;
            if(~isempty(Latitude)|| ~isempty(LatitudeD))
                GPGGA.Latitude = convertLatLong(Latitude,LatitudeD);
            end
            Longitude = dataGGA{index};
            index = index+1;
            LongitudeD = dataGGA{index};
            index = index+1;
            if(~isempty(Longitude) || ~isempty(LongitudeD))
                GPGGA.Longitude = convertLatLong(Longitude,LongitudeD);
            end
            FixStatus = dataGGA{index};
            switch(FixStatus)
                case '0'
                    GPGGA.FixStatus = ['0',' Invalid'];
                case '1'
                    GPGGA.FixStatus = ['1',' GPS Fix'];
                case '2'
                    GPGGA.FixStatus = ['2',' DGPS Fix'];
                case '6'
                    GPGGA.FixStatus = ['6','Estimated Fix'];
                otherwise
                    GPGGA.FixStatus=dataGGA{index};
            end
            index = index+1;
            if(~isempty(dataGGA{index}))
                GPGGA.NumSatelites = str2double(dataGGA{index});
            end
            index = index+1;
            if(~isempty(dataGGA{index}))
                GPGGA.HDOP = str2double(dataGGA{index});
            end
            index = index+1;
            Altitude = dataGGA{index};
            index = index+1;
            AltitudeUnits = dataGGA{index};
            index = index+1;
            if(~isempty(Altitude))
                GPGGA.Altitude= [Altitude,' ',lower(AltitudeUnits)];
            end
            HeightGeoid = double(dataGGA{index});
            index = index+1;
            HeightGeoidUnits = dataGGA{index};
            index = index+1;
            if(~isempty(HeightGeoid))
                GPGGA.HeightofGeoid = [HeightGeoid,' ', lower(HeightGeoidUnits)];
            end
            GPGGA.DiffAge = (dataGGA{index});
            index = index +1;
            GPGGA.DGPSStationID = (dataGGA{index});
            GGA_ChecksumIdx = strfind(dataGGAUnparsed,'*');
            GPGGA.Checksum = char(dataGGAUnparsed(GGA_ChecksumIdx+1:GGA_ChecksumIdx+2));
            GPGGA.ChecksumValidity = validateData(dataGGAUnparsed,GPGGA.Checksum);
        else
            error('Invalid GGA sentence');
        end
    end

% Function to parse VTG Sentences
    function GPVTG = parseVTG(dataVTGUnparsed)
        GPVTG= struct('MessageID','VTG','TrueTrackMadeGood','','MagneticTrackMadeGood','','GroundSpeedinKnots','','GroundSpeedinKmph','','Mode','','Checksum','','ChecksumValidity','');
        dataVTG = (strsplit(dataVTGUnparsed,{seperator,'*'},'CollapseDelimiters',false));
        if(numel(dataVTG)>=10)
            index=1;
            index = index+1;
            TrueTrackMadeGood = dataVTG{index};
            index = index+1;
            TrueTrackMadeGoodwrt = dataVTG{index};
            if(~isempty(TrueTrackMadeGood))
                GPVTG.TrueTrackMadeGood = [TrueTrackMadeGood,' ',TrueTrackMadeGoodwrt];
            end
            index = index+1;
            MagneticTrackMadeGood = dataVTG{index};
            index = index+1;
            MagneticTrackMadeGoodwrt = dataVTG{index};
            if(~isempty(MagneticTrackMadeGood))
                GPVTG.MagneticTrackMadeGood = [MagneticTrackMadeGood,' ',MagneticTrackMadeGoodwrt];
            end
            index = index+1;
            GroundSpeedinKnots = dataVTG{index};
            % Ground Speed Units N(Knots) is fixed text
            index = index+2;
            if(~isempty(GroundSpeedinKnots))
                GPVTG.GroundSpeedinKnots= [GroundSpeedinKnots,' knots'] ;
            end
            GroundSpeedinKmperhr = dataVTG{index};
            % Ground Speed Units k(kmph) is fixed text
            index = index+2;
            if(~isempty(GroundSpeedinKmperhr))
                GPVTG.GroundSpeedinKmph= [GroundSpeedinKmperhr,' km/hr'] ;
            end
            if(numel(dataVTG)>10)
                % NMEA version >2.3, doesnt provide this feild.
                Mode = dataVTG{index};
                switch(Mode)
                    case 'N'
                        GPVTG.Mode = 'N,No Fix';
                    case 'A'
                        GPVTG.Mode = 'A,Autonomous GNSS Fix';
                    case 'D'
                        GPVTG.Mode = 'D,Differential GNSS Fix';
                    case 'E'
                        GPVTG.Mode = 'E,Estimated/Dead Reckoning Fix';
                    otherwise
                        GPVTG.Mode=dataVTG{index};
                end
            end
            VTG_ChecksumIdx = strfind(dataVTGUnparsed,'*');
            GPVTG.Checksum = char(dataVTGUnparsed(VTG_ChecksumIdx+1:VTG_ChecksumIdx+2));
            GPVTG.ChecksumValidity = validateData(dataVTGUnparsed,GPVTG.Checksum);
        else
            error('Invalid GSA sentence');
        end
    end

% Function to parse GSA Sentences
    function GPGSA = parseGSA(dataGSAUnparsed)
        GPGSA= struct('MessageID','GSA','SelectionofFix','','FixType','','PRNs','','PDOP','','HDOP','','VDOP','','Checksum','','ChecksumValidity','');
        dataGSA = (strsplit(dataGSAUnparsed,{seperator,'*'},'CollapseDelimiters',false));
        if(numel(dataGSA)>=19)
            index=1;
            index = index+1;
            SelectionofFix = dataGSA{index};
            switch (SelectionofFix)
                case 'A'
                    GPGSA.SelectionofFix = 'A Automatic';
                case 'M'
                    GPGSA.SelectionofFix = 'M Manual';
                otherwise
                    GPGSA.SelectionofFix = dataGSA(index);
            end
            index = index+1;
            FixType = dataGSA{index};
            switch FixType
                case '1'
                    GPGSA.FixType = '1,Fix not available';
                case '2'
                    GPGSA.FixType = '2,2D Fix';
                case '3'
                    GPGSA.FixType = '3,3D Fix';
                otherwise
                    GPGSA.FixType = dataGSA(index);
            end
            index = index+1;
            i=index;
            temp=[];
            while(~isempty(dataGSA{i}))
                temp = [temp,str2double(dataGSA{i})];
                i=i+1;
            end
            GPGSA.PRNs = temp;
            index = index+12;
            if(~isempty(dataGSA{index}))
                GPGSA.PDOP = str2double(dataGSA{index});
            end
            index = index+1;
            if(~isempty(dataGSA{index}))
                GPGSA.HDOP = str2double(dataGSA{index});
            end
            index = index+1;
            if(~isempty(dataGSA{index}))
                GPGSA.VDOP = str2double(dataGSA{index});
            end
            GSA_ChecksumIdx = strfind(dataGSAUnparsed,'*');
            GPGSA.Checksum = char(dataGSAUnparsed(GSA_ChecksumIdx+1:GSA_ChecksumIdx+2));
            GPGSA.ChecksumValidity = validateData(dataGSAUnparsed,GPGSA.Checksum);
        else
            error('Invalid GSA sentence');
        end
    end

% Function to extract the complete message corresponding to the message ID
    function [unParsedData,noOfMsgs,status] = preprocessGPSData(inData, messageID, endChar)
        % Check if message ID is present in the input
        status = 0;
        noOfMsgs = 0;
        unParsedData=[];
        asterisk = '*';
        startidx = strfind(inData,messageID);
        if(numel(startidx)>=1)
            endindex = strfind(inData,endChar);
            % check for incomplete sentence
            asteriskIndex = strfind(inData,asterisk);
            if(numel(asteriskIndex)==0)
                error('Incomplete NMEA sentence.')
            end
            if(isempty(endindex))
                endindex=numel(inData);
            end
            i=1;
            noOfMsgs = numel(startidx);
            unParsedData = cell(1,noOfMsgs);
            while(i<= noOfMsgs)
                idx = startidx(i);
                % if there are multiple end Characters in the given data,
                % consider the endcharacter after the startCharacter
                endidx = endindex(endindex>idx);
                unParsedData{i} = inData(idx:endidx(1));
                i= i+1;
                status = 1;
            end
        end
    end
% Function to extract and convert latitude and longitude into degrees
    function LatLong = convertLatLong(data,direction)
        idx = strfind(data,'.');
        % The lat and lon is of format ddmm.mmm. Two digits before decimal
        % point is always starting of minutes
        tempfraction = (str2double(data(idx-2:end))/60);
        tempInt = str2double(data(1:idx-3));
        temp = tempInt+tempfraction;
        LatLong = [num2str(temp),degree_symbol,',',direction];
    end
% Function to check if the checksum matches
    function validity = validateData(data,Checksum)
        calculated_checksum = 0;
        % The String inbetween "$" and "*" is considered for checksum
        % calulation
        NMEA_Data = uint16(strtok(data,'*'));
        for count = 1:length(NMEA_Data)
            calculated_checksum = bitxor(calculated_checksum ,NMEA_Data(count));  % checksum calculation
        end
        % convert checksum to hex value
        calculated_checksum  = dec2hex(calculated_checksum);
        % add leading zero to checksum if it is a single digit.
        if (length(calculated_checksum ) == 1)
            calculated_checksum  = strcat('0',calculated_checksum);
        end
        % Check if the calculated checksum is equal to the obtained
        % checksum
        if(strcmp(calculated_checksum,Checksum))
            validity  = 'Correct Checksum';
        else
            validity  = 'Bad Checksum';
        end
    end
end