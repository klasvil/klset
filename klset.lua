script_name('klset')
script_authors('Victor_Windsor and Tobi Genry')

require "lib.moonloader"

local ev = require'samp.events'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local key = require 'vkeys'

 

update_state = false
activiti = true
index = 1
lock = false
idplayer = {}
tt = {}
tt2 = {}
warn = {}
dialogArr = {}
dialogArr2 = {}
warn2 = {}
check = {}
local main_window_state = imgui.ImBool(false)
local sec_window_state = imgui.ImBool(false)
local sec = imgui.ImBool(true)

local script_vers = 5
local script_vers_text = "3.21"

local update_url = "https://raw.githubusercontent.com/klasvil/klset/main/update.ini"
local update_path = getWorkingDirectory() .."/update.ini"

local script_url = "https://raw.githubusercontent.com/klasvil/klset/main/klset.lua"
local script_path = thisScript().path


function main()



    if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(0)
	end
    repeat wait(0) until sampIsLocalPlayerSpawned()

    downloadUrlToFile(update_url, update_path, function(id,status )
    if status == dlstatus.STATUSEX_ENDDOWNLOAD then

        updateIni = inicfg.load(nil, update_path)
       if tonumber(updateIni.info.vers) > script_vers then
            sampAddChatMessage(u8:decode("Есть обновление!"), -1)
            update_state = true
        end
        end
    end)

    
    sampAddChatMessage(u8:decode('{00AAFF}[KlSet]{FFFFFF} - Для поиска нарушителей аксесуаров пропишите команду {00AAFF}/skillsall '), -1)
    sampAddChatMessage(u8:decode('{00AAFF}[KlSet]{FFFFFF} - Для поиска нарушителей Ранга(бандиты) {00AAFF}/checkall{FFFFFF} '), -1)
    sampAddChatMessage(u8:decode('{00AAFF}[KlSet]{FFFFFF} - Если вы забыли команды {00AAFF}/allhelp{FFFFFF} '), -1)


    sampRegisterChatCommand("allhelp", function()
        sampAddChatMessage('', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage(u8:decode('Для поиска нарушителей аксесуаров пропишите команду /skillsall '), -1)
        sampAddChatMessage(u8:decode('Для поиска нарушителей Ранга(бандиты) /checkall '), -1)
        sampAddChatMessage(u8:decode('Для выключения активации меню на "X" /alloff '), -1)
        sampAddChatMessage(u8:decode('Для включения активации меню на "X" /allon '), -1)
    end)


    sampRegisterChatCommand("alloff", alloff)
    sampRegisterChatCommand("allon", allon)
    sampRegisterChatCommand("skillsall", skillsall)
    sampRegisterChatCommand("checkall", checkall)
    sampRegisterChatCommand("list", list)
    sampRegisterChatCommand("list2", list2)

    while true do
        wait(0)
      

        if activiti then
            if wasKeyPressed(key.VK_X) then -- активация по нажатию клавиши X
                main_window_state.v = not main_window_state.v -- переключаем статус активности окна, не забываем про .v
                imgui.Process = main_window_state.v
            end
        end 

        if update_state then

            downloadUrlToFile(script_url, script_path, function(id,status )
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage(u8:decode("Скрипт успешно обнавлен!"), -1)
                    ThisScript():reload()
                end
            end)
        end
    end
end
       
function imgui.OnDrawFrame()

    if main_window_state.v then -- чтение и запись значения такой переменной осуществляется через поле v (или Value)
        imgui.SetNextWindowSize(imgui.ImVec2(180, 280), imgui.Cond.FirstUseEver) -- меняем размер
        
        imgui.Begin('klset', main_window_state)
            
            if imgui.Button('Список нарушителей рангов') then -- а вот и кнопка с действием
        
            sec_window_state.v = true
            
            end 
          imgui.Text('Список нарушителей обвесы + аксы')
                     
        for i = 1, #dialogArr do
            name = sampGetPlayerNickname(dialogArr[i])
            if imgui.Button(name..'['..dialogArr[i]..']') then -- а вот и кнопка с действием
          
                sampSendChat('/re '..dialogArr[i])
    
            end 
           
        end
        imgui.End()
    end

    if sec_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(180, 281), imgui.Cond.FirstUseEver) -- меняем размер
        imgui.Begin('klset2',sec_window_state)
        for i = 1, #dialogArr2 do
            name = sampGetPlayerNickname(dialogArr2[i])
            if imgui.Button(name..'['..dialogArr2[i]..']') then -- а вот и кнопка с действием
          
                sampSendChat('/re '..dialogArr2[i])
    
            end 

        end
        imgui.End()
    end

end
 
function skillsall()
       lua_thread.create(function()
         local peds = getAllChars()
    for _, v  in pairs(peds) do
            local result, id = sampGetPlayerIdByCharHandle(v)
        if result and id ~= sampGetPlayerIdByCharHandle(PLAYER_PED) then
                idplayer[index] = id
               
                index = index + 1
        end
    end
    
    if #idplayer == 1 then 

        return

    end
    wait(300)    
    for i = 1, #idplayer do
            sampSendChat('/checkskills '..idplayer[i]..' 3')
            tt[i] = sampGetDialogText()
            wait(320) 
    end
        
    for i = 1, #idplayer do
            sampSendChat('/checkskills '..idplayer[i]..' 2')
            tt2[i] = sampGetDialogText()
            wait(320) 
    end
        
            id = 2 
            index = 0 
             for i = 1, #idplayer do

                if tt[id] ~= nil then
                     e = tt[id] 
                end

              
                   
           -- print(sampGetPlayerNickname(idplayer[i])..'['..idplayer[i]..']')
           
                for s in e:gmatch("[^\r\n]+") do
                   if index ~= 0 then
                   
                    result = string.match(s, "[+]%d+")
                    result = tonumber(result)
                    -- print(s)
                    -- print(result)
                    if result == nil then
                 
                        else
                        if result >= 4 or nil then
                      warn[i] = idplayer[i]
                      
                      end

                    end
                end
                index = index + 1
            end
            id = id + 1 
        end
        --print('-----------------------------')
         
        id = 2 
        index = 0 
        
         for i = 1  , #idplayer do
            if tt2[id] ~= nil then

                e = tt2[id] 
           
            end
            if tt2[id] == nil then
                  
            end
               
       -- print(sampGetPlayerNickname(idplayer[i])..'['..idplayer[i]..']')
            ii = 1
              for s in e:gmatch("[^\r\n]+") do
               if index ~= 0 then
               
                result = string.match(s, "[(]%w+")
               
                
                if result == nil then
                
                    else
                    if result ~= nil then
                       
                    warn[i] = idplayer[i]
                    
                    end
                    
                end
            end
            index = index + 1
        end
        id = id + 1 
        end
      

        ii = 1
        for i = 1, #idplayer do
            
            
                if warn[i] == nil then
                    
                    else
                        if warn[i] ~= nil then 
                           dialogArr[ii] = warn[i]
                           ii = ii + 1
                        end
                            
                        
                            
                            
                    sampAddChatMessage(u8:decode('Нарушитель найден ')..sampGetPlayerNickname(warn[i])..'['..warn[i]..']', 0x00DD00)
                    textID = sampCreate3dText('WARN', -1, 0, 0, -1.1, 800.0, true, warn[i], 0)
                    dialogStr = ''
                    

                end
                
            end
          
    end)
end

function checkall()
    lua_thread.create(function()
        local peds = getAllChars()
       for _, v  in pairs(peds) do
           local result, id = sampGetPlayerIdByCharHandle(v)
           if result and id ~= sampGetPlayerIdByCharHandle(PLAYER_PED) then
               idplayer[index] = id
              
               index = index + 1
           end
       end 
      
        if #idplayer == 1 then 

         return

        end
        wait(300) 
        for i = 1, #idplayer do
            sampSendChat('/check '..idplayer[i])
            check[i] = sampGetDialogText()
            wait(350) 
        end
            id = 2
        for i = 1  , #idplayer do
            if check[id] ~= nil then
        
                e = check[id] 
           
            end
            if check[id] == nil then
                  
            end
               
          
              for s in e:gmatch("[^\r\n]+") do
                if index ~= 0 then
                    result = string.match(s, "[[]%u%w+")
                   
                    
                    if result ~= nil then
                    result2 = string.match(result, "%u%w+")
                

                    end
                    Los = 'Los'
                    Grove = 'Grove'
                    The = 'The'
                    Varrios = 'Varrios'
                    East = 'East'
                    Night = 'Night'

                    if result2 == Los then
                       
                     
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")

                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                       
                                    if num < 4  then
                                     warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end

                     
                    elseif result2 == Grove then
                   
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")
                             
                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                        
                                    if num < 4  then
                                        warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end


                    elseif result2 == Varrios then
                     --   print('+')
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")
                             
                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                       
                                    if num < 4  then
                                        warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end


                    elseif result2 == The then
                     --   print('+')
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")
                             
                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                        
                                    if num < 4  then
                                        warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end


                    elseif result2 == East then
                     --   print('+')
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")
                             
                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                
                                    if num < 4  then
                                        warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end

                    
                    elseif result2 == Night then
                    
                        for ss in e:gmatch("[^\r\n]+") do
                            if index ~= 0 then
                                result = string.match(ss, "[(]%d[)]")
                             
                                
                                if result == nil then
                             
                                    else
                                        result2 = string.match(result, "%w+")
                                        local num = tonumber(result2)
                                        
                                    if num < 4  then
                                        warn2[i] = idplayer[i]
                                    end
                                end
                            end
                        end


                        
                    end

                end
                    index = index + 1
                end
            id = id + 1 
        end

            ii = 1
        for i = 1, #idplayer do
         --   print(warn2[i])
                if warn2[i] == nil then
                    else
                        if warn2[i] ~= nil then 
                            dialogArr2[ii] = warn2[i]
                            ii = ii + 1
                         end
                       
                    sampAddChatMessage(u8:decode('Бандит низкого ранга ')..sampGetPlayerNickname(warn2[i])..'['..warn2[i]..']', 0x00DD00)
                    textID = sampCreate3dText('WARN2', -1, 0, 0, -1.1, 800.0, true, warn2[i], 0)
                     
                end
        end

           
          
           

            

        
           
    end)
end

function list(agr)
    main_window_state.v = not main_window_state.v -- переключаем статус активности окна, не забываем про .v
    
end
   

function list2(agr)
    sec_window_state.v = not sec_window_state.v -- переключаем статус активности окна, не забываем про .v
    imgui.Process = sec_window_state.v
end

function list2(agr)
    sec_window_state.v = not sec_window_state.v -- переключаем статус активности окна, не забываем про .v
    imgui.Process = sec_window_state.v
end

function alloff(agr)

    activiti = false
    sampAddChatMessage(u8:decode('Активация на "X" Выключена'), -1)

end

function allon(agr)

    activiti = true
    sampAddChatMessage(u8:decode('Активация на "X" Включена'), -1)
end