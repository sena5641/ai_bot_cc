-- Получение внешнего монитора
local monitor = peripheral.find("monitor")
if not monitor then
    monitor = term()
end

monitor.clear()
monitor.setTextScale(0.5)

-- Логотип
local fun_logo = {
    "     ___                    ",
    "    /     |   |  |\\  |      ",
    "   /__    |   |  | \\ |      ",
    "  /       |___|  |  \\| . inc"
}

-- Анимированные кадры
local loader_frames = {
    "   ",
    "|_|",
    " _ ",
    "|_ ",
    " _ ",
    "| |",
    " _ ",
    " _|"
}

-- Получаем размеры экрана
local xu, yu = monitor.getSize()
local fr = 1
local loaded = false
local error_occurred = false

-- Отрисовка логотипа
local logo_height = #fun_logo
local start_y = 2

for i, line in ipairs(fun_logo) do
    monitor.setCursorPos(math.floor((xu - #line) / 2), start_y + i - 1)
    monitor.write(line)
end

-- Создание окна для анимации
local win_width = 3
local win_height = 2
local my_window = window.create(
    monitor,
    math.floor((xu - win_width) / 2),
    start_y + logo_height + 2,
    win_width,
    win_height
)

my_window.setBackgroundColor(colors.black)
my_window.setTextColor(colors.white)

local function showError(err_text)
    error_occurred = true
    loaded = true
    
    -- Очистка области под анимацией
    monitor.clear()
    
    -- Отрисовка логотипа и ошибки
    local logo_height = #fun_logo
    local start_y = 2
    
    for i, line in ipairs(fun_logo) do
        monitor.setCursorPos(math.floor((xu - #line) / 2), start_y + i - 1)
        monitor.write(line)
    end
    
    monitor.setTextColor(colors.red)
    monitor.setCursorPos(math.floor((xu - #err_text) / 2), start_y + logo_height + 2)
    monitor.write(err_text)
    monitor.setTextColor(colors.white)
end

-- Проверка API
local function checkOpenRouterAPI()
    local ok, response = pcall(function()
        return http.get("https://openrouter.ai/api/v1", nil, true)
    end)
    
    if not ok then
        showError("Network error")
        return false
    end
    
    if not response then
        showError("No API response")
        return false
    end
    
    local status = response.getResponseCode()
    response.close()
    
    if status ~= 200 then
        showError("API Error: "..tostring(status))
        return false
    end
    
    return true
end

-- Анимация
local function runAnimation()
    while not loaded do
        my_window.clear()
        
        -- Обновляем кадры
        my_window.setCursorPos(1, 1)
        my_window.write(loader_frames[fr])
        
        my_window.setCursorPos(1, 2)
        my_window.write(loader_frames[fr + 1] or loader_frames[1])
        
        fr = fr < (#loader_frames - 1) and fr + 2 or 1
        os.sleep(0.1)
    end
    
    my_window.setVisible(false)
    my_window.clear()
    monitor.clear()
end

-- Основная загрузка
local function mainLoading()
    if not checkOpenRouterAPI() then return end
    
    -- Имитация загрузки
    for _ = 1, 5 do
        if error_occurred then break end
        os.sleep(0.5)
    end
    
    if not error_occurred then loaded = true end
end

-- Запуск
parallel.waitForAny(runAnimation, mainLoading)

-- Восстановление позиции курсора на основном терминале
term.setCursorPos(1, 1)