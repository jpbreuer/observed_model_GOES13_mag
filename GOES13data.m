clear all;close all

startTime = {'2013-05-31 23:00:00';'2013-05-31 23:00:00';'2013-06-01 03:00:00';'2013-06-01 07:00:00';'2013-06-01 12:00:00'};
endTime = {'2013-06-02 00:00:00';'2013-06-01 03:00:00';'2013-06-01 07:00:00';'2013-06-01 11:00:00';'2013-06-02 00:00:00'};
condition = {'full';'start_peak';'decline';'low';'recovery'};

for ii = 1:5
    current = condition{ii};
    for model = 1:2
        switch model % 1 = observation; 2 = model
            case 1
                api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
                url = sprintf([api '?format=text&quantity=Hp,He,Hn,TotalField&resource=GOES-13,GOES-13,GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13,GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
                filename = 'observed_mag.txt';
                outfilename = websave(filename,url);
                data = importdata('observed_mag.txt',' ',1);

%                 data = importdata('20130316_0321_GOES13.txt',' ',1);
            
                Timestamp = [strcat(data.textdata(2:end,1),{' '},data.textdata(2:end,2))];
                Hp = data.data(:,1);He = data.data(:,2);Hn = data.data(:,3);TotalField = data.data(:,4);
                data = data.data;
            case 2
                data = importdata('model_pointdata.txt',' ',7);
    
                labels = data.textdata{6};labels = regexprep(labels,'# ','');
                beginTime = data.textdata{5};beginTime = beginTime(regexp(beginTime,'2013'):end);
                data = data.data;
            
                Timestamp = cellstr(datestr(cellstr(datestr(data(:,1)/86400+datenum(datevec(beginTime)))),'yyyy-mm-dd HH:MM:SS'));
                TotalField = data(:,end);
        end
    
        startIndex = strfind(Timestamp,startTime{ii});
        endIndex = strfind(Timestamp,endTime{ii});
        startIndex = find(not(cellfun('isempty', startIndex)));
        endIndex = find(not(cellfun('isempty', endIndex)));
    
        t = datenum(Timestamp);
        dt = length(startIndex:endIndex);
%     plotRange = linspace(0,1,dt);
        plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);
    
%     ts = timeseries(TotalField,Timestamp);
%     ts.Name = 'GOES13 vs Model Absolute Mag Data';
%     ts.TimeInfo.Units = 'hours';
%     ts.TimeInfo.StartDate = startTime;     % Set start date.
%     ts.TimeInfo.Format = 'mm-dd HH:mm';       % Set format for display on x-axis.
%     ts.Time = ts.Time - ts.Time(1);        % Express time relative to the start date.
%     plot(ts)
% end
        figure(ii);
        plot(plotRange,TotalField(startIndex:endIndex));hold on;
%     plot(t(startIndex:endIndex),TotalField(startIndex:endIndex));hold on;
%     datetic('x','yyyy-mm-dd HH:MM:SS')
    
        if strcmp(current,'full') == 1
            xlabel('Time');ylabel('B Total Field [nT]');
            title(sprintf('Full Event: %s to %s', startTime{ii},endTime{ii}));
            legend({'Observed Data','Model Data'},'FontSize',8,'FontWeight','bold');
            set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
            set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'HH:MM'));
            print(gcf, '-dpdf', 'fullevent_GOES13_mag.pdf');
        elseif strcmp(current,'start_peak') == 1
            xlabel('Time');ylabel('B Total Field [nT]');
            title(sprintf('Event Start to Peak: %s to %s', startTime{ii},endTime{ii}));
            legend({'Observed Data','Model Data'},'FontSize',8,'FontWeight','bold')
            set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
            set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'HH:MM'));
            print(gcf, '-dpdf', 'start_peak_GOES13_mag.pdf');
        elseif strcmp(current,'decline') == 1
            xlabel('Time');ylabel('B Total Field [nT]');
            title(sprintf('Event Decline Post-peak: %s to %s', startTime{ii},endTime{ii}));
            legend({'Observed Data','Model Data'},'FontSize',8,'FontWeight','bold')
            set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
            set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'HH:MM'));
            print(gcf, '-dpdf', 'decline_GOES13_mag.pdf');
        elseif strcmp(current,'low') == 1
            xlabel('Time');ylabel('B Total Field [nT]');
            title(sprintf('Event Low Point: %s to %s', startTime{ii},endTime{ii}));
            legend({'Observed Data','Model Data'},'FontSize',8,'FontWeight','bold')
            set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
            set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'HH:MM'));
            print(gcf, '-dpdf', 'low_GOES13_mag.pdf');
        elseif strcmp(current,'recovery') == 1
            xlabel('Time');ylabel('B Total Field [nT]');
            title(sprintf('Event Recovery Period: %s to %s', startTime{ii},endTime{ii}));
            legend({'Observed Data','Model Data'},'FontSize',8,'FontWeight','bold')
            set(gca, 'xtick',plotRange(1:length(plotRange)/6:end));
            set(gca, 'xticklabel',datestr(plotRange(1:length(plotRange)/6:end),'HH:MM'));
            print(gcf, '-dpdf', 'recovery_GOES13_mag.pdf');
        end
    end
end

