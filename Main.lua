IsRun = true;
IsActive = true;
nameInstrument = "nameInstrument";

function OnInit()
	-- При запуске бота возьмем все инструменты и их коды
	fInst = io.open("instrument.req","w");
	local listString = getClassesList();
	for w in string.gmatch(listString, "[^,]+") do
		local classCode = w; 
		local secList = getClassSecurities(classCode);
		for secCode in string.gmatch(secList, "[^,]+") do
			local stringOutput = classCode..';'..secCode..'\n';
			local tableSI = getSecurityInfo(classCode,secCode);
			local stringOutput = classCode..';'..secCode..';'..tableSI.name..';'..tableSI.short_name..';'..tableSI.class_code..';'..tableSI.class_name..'\n';
			fInst:write(stringOutput);
		end;
	end;

  	fInst:flush();
    fInst:close();
end;

function main()
   IsRun = true;
   IsActive = true;
   
   while IsActive do
   
			--message('ран');
			
			local time = os.date("*t");
			local timeString=tostring(time.year)..tostring(time.month)..tostring(time.day)..'_'..tostring(time.hour).. tostring(time.min) .. tostring(time.sec);
			fVolat   = io.open("volatility_"..timeString..".req","w"); 
			fQty     = io.open("qty_"..timeString..".req","w");
			fPrice   = io.open("price_"..timeString..".req","w");
			fOpinter = io.open("openint_"..timeString..".req","w");
			
			local timeStart = os.date("*t");
			timeStart.hour = 0;
			timeStart.min = 0;
			timeStart.sec = 0;
		
		
		    -- Пытается открыть файл в режиме "чтения/записи"
			local copy_file = require("util").copy_file;
			copy_file("nameInstrument.req", "nameInstrumentCopy.req");
			f = io.open("nameInstrumentCopy.req","r+");
			-- Если файл существует
			if f ~= nil then
				--message('open');
				-- Открывает уже существующий файл в режиме "чтения/записи"
				f = io.open("nameInstrumentCopy.req","r");	
				f:seek("set",0);
				-- Перебирает строки файла
				for line in f:lines() do 
					local itemNames={};
					local countArray = 1;
					for el in string.gmatch(line, "[^;]+") do
						itemNames[countArray] = el;
						countArray = countArray + 1;
					end;
					if (table.getn(itemNames))>1 then 
						-- волатильность
						ds, Error = CreateDataSource(itemNames[1], itemNames[2], INTERVAL_M1, "VOLATILITY");
						--while (Error == "" or Error == nil) and ds:Size() == 0 do sleep(1) end
						if Error ~= "" and Error ~= nil then
							--ds:SetEmptyCallback();
							--message(Error);
						else
							for i=1,ds:Size() do	
								local close = ds:C(i);
								local datetime = ds:T(i);
								if os.time(datetime)>os.time(timeStart) then
									local datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(datetime.hour)..':'..tostring(datetime.min)..':'..tostring(datetime.sec);
									if (i==ds:Size()) then 
										datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(GetInfoParam("SERVERTIME"));     
									end;
									local text = itemNames[1]..';'..itemNames[2]..';'..datetimestring..';'..tostring(close)..'\n';	
									fVolat:write(text);
								end;
							end;
						end;
						-- объем
						ds, Error = CreateDataSource(itemNames[1], itemNames[2], INTERVAL_M1, "BID");
						--while (Error == "" or Error == nil) and ds:Size() == 0 do sleep(1) end
						if Error ~= "" and Error ~= nil then
							--ds:SetEmptyCallback();
						else
							for i=1,ds:Size() do	
								local close = ds:V(i);
								local datetime = ds:T(i);
								if os.time(datetime)>os.time(timeStart) then
									local datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(datetime.hour)..':'..tostring(datetime.min)..':'..tostring(datetime.sec);
									if (i==ds:Size()) then 
										datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(GetInfoParam("SERVERTIME"));     
									end;
									local text = itemNames[1]..';'..itemNames[2]..';'..datetimestring..';'..tostring(close)..'\n';	
									fQty:write(text);
								end;
							end;
						end;
						-- цена
						ds, Error = CreateDataSource(itemNames[1], itemNames[2], INTERVAL_M1, "BID");
						--while (Error == "" or Error == nil) and ds:Size() == 0 do sleep(1) end
						if Error ~= "" and Error ~= nil then
							--ds:SetEmptyCallback();
						else
							for i=1,ds:Size() do	
								local close = ds:C(i);
								local datetime = ds:T(i);
								if os.time(datetime)>os.time(timeStart) then
									local datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(datetime.hour)..':'..tostring(datetime.min)..':'..tostring(datetime.sec);
									if (i==ds:Size()) then 
										datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(GetInfoParam("SERVERTIME"));     
									end;
									local text = itemNames[1]..';'..itemNames[2]..';'..datetimestring..';'..tostring(close)..'\n';	
									fPrice:write(text);
								end;
							end;
						end;
						-- открытый интерес
						ds, Error = CreateDataSource(itemNames[1], itemNames[2], INTERVAL_M1, "NUMCONTRACTS");
						--while (Error == "" or Error == nil) and ds:Size() == 0 do sleep(1) end
						if Error ~= "" and Error ~= nil then
							--ds:SetEmptyCallback();
							--message(Error);
						else
							for i=1,ds:Size() do	
								local close = ds:C(i);
								local datetime = ds:T(i);
								if os.time(datetime)>os.time(timeStart) then
									local datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(datetime.hour)..':'..tostring(datetime.min)..':'..tostring(datetime.sec);
									if (i==ds:Size()) then 
										datetimestring = tostring(datetime.year)..'-'..tostring(datetime.month)..'-'..tostring(datetime.day)..' '..tostring(GetInfoParam("SERVERTIME"));     
									end;
									local text = itemNames[1]..';'..itemNames[2]..';'..datetimestring..';'..tostring(close)..'\n';	
									fOpinter:write(text);
								end;
							end;
						end;
					end; --if (table.getn(itemNames))>1 then 
				end;
				-- Закрывает файл
				f:close();
			end;
			
			fPrice:flush();
			fPrice:close();
			
			fVolat:flush();
			fVolat:close();

			fQty:flush();
			fQty:close();
			
			fOpinter:flush();
			fOpinter:close();

			sleep(60000);
		--end;
   end;
end;

function OnStop()
   IsRun = false;
   IsActive = false;
end;