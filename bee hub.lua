-- GuiLib.lua 0.0.3
local GuiLib = {}
GuiLib.__index = GuiLib

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

-- =====================
--  Дефолтная тема
-- =====================
local DefaultTheme = {
    Background   = Color3.fromRGB(30, 30, 35),
    TopBar       = Color3.fromRGB(20, 20, 25),
    Sidebar      = Color3.fromRGB(22, 22, 28),
    Accent       = Color3.fromRGB(100, 160, 255),
    Text         = Color3.fromRGB(240, 240, 240),
    TextDim      = Color3.fromRGB(160, 160, 170),
    Border       = Color3.fromRGB(55, 55, 65),
    CornerRadius = UDim.new(0, 8),
    Transparency = 0,
}

-- =====================
--  Встроенные пресеты
-- =====================
GuiLib.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 35),
        TopBar     = Color3.fromRGB(20, 20, 25),
        Sidebar    = Color3.fromRGB(22, 22, 28),
        Accent     = Color3.fromRGB(100, 160, 255),
        Border     = Color3.fromRGB(55, 55, 65),
    },
    Light = {
        Background = Color3.fromRGB(235, 235, 240),
        TopBar     = Color3.fromRGB(210, 210, 220),
        Sidebar    = Color3.fromRGB(200, 200, 212),
        Accent     = Color3.fromRGB(60, 120, 220),
        Border     = Color3.fromRGB(180, 180, 190),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 20),
        TopBar     = Color3.fromRGB(5, 5, 15),
        Sidebar    = Color3.fromRGB(8, 8, 18),
        Accent     = Color3.fromRGB(150, 80, 255),
        Border     = Color3.fromRGB(40, 40, 60),
    },
    Crimson = {
        Background = Color3.fromRGB(28, 15, 15),
        TopBar     = Color3.fromRGB(18, 8, 8),
        Sidebar    = Color3.fromRGB(20, 10, 10),
        Accent     = Color3.fromRGB(220, 60, 60),
        Border     = Color3.fromRGB(70, 30, 30),
    },
    Forest = {
        Background = Color3.fromRGB(15, 28, 18),
        TopBar     = Color3.fromRGB(8, 18, 10),
        Sidebar    = Color3.fromRGB(10, 22, 13),
        Accent     = Color3.fromRGB(60, 200, 100),
        Border     = Color3.fromRGB(30, 65, 38),
    },
    Ocean = {
        Background = Color3.fromRGB(12, 22, 35),
        TopBar     = Color3.fromRGB(7, 14, 25),
        Sidebar    = Color3.fromRGB(9, 18, 30),
        Accent     = Color3.fromRGB(0, 180, 220),
        Border     = Color3.fromRGB(20, 50, 80),
    },
}

-- =====================
--  Helpers
-- =====================
local function merge(base, override)
    local result = {}
    for k, v in pairs(base) do result[k] = v end
    if override then
        for k, v in pairs(override) do result[k] = v end
    end
    return result
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 8)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(55, 55, 65)
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function lighten(color, amount)
    return Color3.fromRGB(
        math.clamp(color.R * 255 + amount, 0, 255),
        math.clamp(color.G * 255 + amount, 0, 255),
        math.clamp(color.B * 255 + amount, 0, 255)
    )
end

-- =====================
--  CreateWindow
-- =====================
function GuiLib:CreateWindow(config)
    if type(config) == "string" then
        config = { Title = config }
    end
    config = config or {}

    local theme = merge(DefaultTheme, config.Theme)

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GuiLib"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    -- Основной фрейм
    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = UDim2.new(0, 560, 0, 520)
    frame.Position = UDim2.new(0.5, -280, 0.5, -260)
    frame.BackgroundColor3 = theme.Background
    frame.BackgroundTransparency = theme.Transparency
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    addCorner(frame)
    local frameStroke = addStroke(frame, theme.Border)

    -- Топбар
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 42)
    topBar.BackgroundColor3 = theme.TopBar
    topBar.BackgroundTransparency = theme.Transparency
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    addCorner(topBar)

    local patch = Instance.new("Frame")
    patch.Size = UDim2.new(1, 0, 0, 8)
    patch.Position = UDim2.new(0, 0, 1, -8)
    patch.BackgroundColor3 = theme.TopBar
    patch.BackgroundTransparency = theme.Transparency
    patch.BorderSizePixel = 0
    patch.Parent = topBar

    -- Акцентная полоса
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.new(0, 10, 0, 8)
    accentBar.BackgroundColor3 = theme.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = topBar
    addCorner(accentBar, UDim.new(1, 0))

    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Title or "Window"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 22, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = topBar

    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    closeBtn.TextColor3 = theme.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topBar
    addCorner(closeBtn, UDim.new(0, 6))

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(240, 90, 90)
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- =====================
    --  Сайдбар (слева)
    -- =====================
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 130, 1, -50)
    sidebar.Position = UDim2.new(0, 8, 0, 50)
    sidebar.BackgroundColor3 = theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = frame
    addCorner(sidebar)
    addStroke(sidebar, theme.Border)

    -- Лого/иконка вверху сайдбара
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(1, -16, 0, 60)
    logoFrame.Position = UDim2.new(0, 8, 0, 8)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = sidebar

    local logoIcon = Instance.new("TextLabel")
    logoIcon.Text = config.Icon or "✦"
    logoIcon.Size = UDim2.new(0, 28, 0, 28)
    logoIcon.Position = UDim2.new(0.5, -14, 0, 6)
    logoIcon.BackgroundTransparency = 1
    logoIcon.TextColor3 = theme.Accent
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.TextSize = 20
    logoIcon.Parent = logoFrame

    local logoTitle = Instance.new("TextLabel")
    logoTitle.Text = config.Title or "Menu"
    logoTitle.Size = UDim2.new(1, 0, 0, 18)
    logoTitle.Position = UDim2.new(0, 0, 0, 36)
    logoTitle.BackgroundTransparency = 1
    logoTitle.TextColor3 = theme.TextDim
    logoTitle.Font = Enum.Font.Gotham
    logoTitle.TextSize = 10
    logoTitle.Parent = logoFrame

    -- Разделитель
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -16, 0, 1)
    divider.Position = UDim2.new(0, 8, 0, 72)
    divider.BackgroundColor3 = theme.Border
    divider.BorderSizePixel = 0
    divider.Parent = sidebar

    -- Список вкладок
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -82)
    tabList.Position = UDim2.new(0, 0, 0, 80)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabList

    local tabListPadding = Instance.new("UIPadding")
    tabListPadding.PaddingLeft = UDim.new(0, 6)
    tabListPadding.PaddingRight = UDim.new(0, 6)
    tabListPadding.PaddingTop = UDim.new(0, 4)
    tabListPadding.Parent = tabList

    -- =====================
    --  Контент (справа)
    -- =====================
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -148, 1, -58)
    contentArea.Position = UDim2.new(0, 146, 0, 50)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.Parent = frame

    -- Объект окна
    local window = setmetatable({}, GuiLib)
    window._frame       = frame
    window._topBar      = topBar
    window._patch       = patch
    window._accentBar   = accentBar
    window._stroke      = frameStroke
    window._sidebar     = sidebar
    window._tabList     = tabList
    window._contentArea = contentArea
    window._theme       = theme
    window._titleLbl    = titleLabel
    window._tabs        = {}
    window._activeTab   = nil

    return window
end

-- =====================
--  :AddTab(config)
-- =====================
function GuiLib:AddTab(config)
    if type(config) == "string" then
        config = { Title = config }
    end
    config = config or {}

    local theme = self._theme
    local isFirst = #self._tabs == 0

    -- Кнопка вкладки в сайдбаре
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. (config.Title or "Tab")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = theme.Accent
    tabBtn.BackgroundTransparency = isFirst and 0 or 1
    tabBtn.Text = ""
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self._tabList
    addCorner(tabBtn, UDim.new(0, 6))

    -- Индикатор слева
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.55, 0)
    indicator.Position = UDim2.new(0, 0, 0.225, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BackgroundTransparency = isFirst and 0 or 1
    indicator.BorderSizePixel = 0
    indicator.Parent = tabBtn
    addCorner(indicator, UDim.new(1, 0))

    -- Иконка
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Text = config.Icon or "◈"
    tabIcon.Size = UDim2.new(0, 24, 1, 0)
    tabIcon.Position = UDim2.new(0, 8, 0, 0)
    tabIcon.BackgroundTransparency = 1
    tabIcon.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or theme.TextDim
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextSize = 14
    tabIcon.Parent = tabBtn

    -- Текст
    local tabText = Instance.new("TextLabel")
    tabText.Text = config.Title or "Tab"
    tabText.Size = UDim2.new(1, -36, 1, 0)
    tabText.Position = UDim2.new(0, 34, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or theme.TextDim
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Font = isFirst and Enum.Font.GothamBold or Enum.Font.Gotham
    tabText.TextSize = 12
    tabText.Parent = tabBtn

    -- =====================
    --  Контент вкладки
    -- =====================
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "Content_" .. (config.Title or "Tab")
    tabContent.Size = UDim2.new(1, -8, 1, -8)
    tabContent.Position = UDim2.new(0, 0, 0, 4)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = theme.Accent
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    -- Начальное состояние: невидимый и сдвинут вправо
    tabContent.Visible = isFirst
    tabContent.GroupTransparency = isFirst and 0 or 1
    tabContent.Position = UDim2.new(isFirst and 0 or 0.04, 0, 0, 4)
    tabContent.Parent = self._contentArea

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = tabContent

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.Parent = tabContent

    -- Объект вкладки
    local tabObj = setmetatable({}, { __index = self })
    tabObj._btn       = tabBtn
    tabObj._icon      = tabIcon
    tabObj._text      = tabText
    tabObj._indicator = indicator
    tabObj._content   = tabContent
    tabObj._theme     = theme

    table.insert(self._tabs, tabObj)
    if isFirst then self._activeTab = tabObj end

    -- ── Анимации переключения ──
    local tweenFast = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenSlide = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function activateTab()
        if self._activeTab == tabObj then return end

        -- Скрываем старую вкладку — уезжает влево + исчезает
        local prev = self._activeTab
        if prev then
            TweenService:Create(prev._content, tweenSlide, {
                GroupTransparency = 1,
                Position = UDim2.new(-0.04, 0, 0, 4),
            }):Play()
            task.delay(0.22, function()
                prev._content.Visible = false
                prev._content.Position = UDim2.new(0.04, 0, 0, 4)
            end)

            -- Кнопка старой: гасим
            TweenService:Create(prev._btn, tweenFast, {
                BackgroundTransparency = 1,
            }):Play()
            TweenService:Create(prev._icon, tweenFast, {
                TextColor3 = theme.TextDim,
            }):Play()
            TweenService:Create(prev._text, tweenFast, {
                TextColor3 = theme.TextDim,
            }):Play()
            TweenService:Create(prev._indicator, tweenFast, {
                BackgroundTransparency = 1,
            }):Play()
            prev._text.Font = Enum.Font.Gotham
        end

        -- Показываем новую — приезжает справа + появляется
        self._activeTab = tabObj
        tabContent.Position = UDim2.new(0.04, 0, 0, 4)
        tabContent.GroupTransparency = 1
        tabContent.Visible = true

        TweenService:Create(tabContent, tweenSlide, {
            GroupTransparency = 0,
            Position = UDim2.new(0, 0, 0, 4),
        }):Play()

        -- Кнопка новой: ярко светлая
        TweenService:Create(tabBtn, tweenFast, {
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(tabIcon, tweenFast, {
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
        TweenService:Create(tabText, tweenFast, {
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
        TweenService:Create(indicator, tweenFast, {
            BackgroundTransparency = 0,
        }):Play()
        tabText.Font = Enum.Font.GothamBold
    end

    -- Hover
    tabBtn.MouseEnter:Connect(function()
        if self._activeTab ~= tabObj then
            TweenService:Create(tabBtn, tweenFast, {
                BackgroundColor3 = lighten(theme.Sidebar, 20),
                BackgroundTransparency = 0,
            }):Play()
            TweenService:Create(tabIcon, tweenFast, {
                TextColor3 = theme.Text,
            }):Play()
            TweenService:Create(tabText, tweenFast, {
                TextColor3 = theme.Text,
            }):Play()
        end
    end)

    tabBtn.MouseLeave:Connect(function()
        if self._activeTab ~= tabObj then
            TweenService:Create(tabBtn, tweenFast, {
                BackgroundTransparency = 1,
            }):Play()
            TweenService:Create(tabIcon, tweenFast, {
                TextColor3 = theme.TextDim,
            }):Play()
            TweenService:Create(tabText, tweenFast, {
                TextColor3 = theme.TextDim,
            }):Play()
        end
    end)

    tabBtn.MouseButton1Click:Connect(activateTab)

    return tabObj
end

-- =====================
--  :SetTheme(preset)
-- =====================
function GuiLib:SetTheme(presetName)
    local preset = GuiLib.Themes[presetName]
    assert(preset, "GuiLib: unknown theme '" .. tostring(presetName) .. "'")

    for k, v in pairs(preset) do self._theme[k] = v end

    self._frame.BackgroundColor3    = preset.Background
    self._topBar.BackgroundColor3   = preset.TopBar
    self._patch.BackgroundColor3    = preset.TopBar
    self._accentBar.BackgroundColor3 = preset.Accent
    self._stroke.Color              = preset.Border
    self._sidebar.BackgroundColor3  = preset.Sidebar
end

-- =====================
--  :SetColor(key, color)
-- =====================
function GuiLib:SetColor(key, color)
    assert(typeof(color) == "Color3", "GuiLib:SetColor — ожидается Color3")
    self._theme[key] = color

    if key == "Background" then
        self._frame.BackgroundColor3 = color
    elseif key == "TopBar" then
        self._topBar.BackgroundColor3 = color
        self._patch.BackgroundColor3  = color
    elseif key == "Accent" then
        self._accentBar.BackgroundColor3 = color
    elseif key == "Border" then
        self._stroke.Color = color
    elseif key == "Sidebar" then
        self._sidebar.BackgroundColor3 = color
    end
end

-- =====================
--  :SetTransparency(value)
-- =====================
function GuiLib:SetTransparency(value)
    value = math.clamp(value, 0, 1)
    self._theme.Transparency = value
    self._frame.BackgroundTransparency  = value
    self._topBar.BackgroundTransparency = value
    self._patch.BackgroundTransparency  = value
end

-- =====================
--  :AddButton(config)
--  Вызывается на объекте вкладки: tab:AddButton({...})
-- =====================
function GuiLib:AddButton(config)
    if type(config) == "string" then
        config = { Text = config }
    end
    config = config or {}

    local theme = self._theme
    local content = self._content

    local container = Instance.new("Frame")
    container.Name = "ButtonContainer"
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundTransparency = 1
    container.Parent = content

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = theme.TopBar
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = container
    addCorner(btn)
    addStroke(btn, theme.Border)

    local leftBar = Instance.new("Frame")
    leftBar.Size = UDim2.new(0, 3, 0.6, 0)
    leftBar.Position = UDim2.new(0, 0, 0.2, 0)
    leftBar.BackgroundColor3 = theme.Accent
    leftBar.BorderSizePixel = 0
    leftBar.Parent = btn
    addCorner(leftBar, UDim.new(1, 0))

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = config.Icon or ""
    iconLabel.TextColor3 = theme.Accent
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Parent = btn

    local textOffset = (config.Icon ~= nil and config.Icon ~= "") and 40 or 14
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -textOffset - 10, 1, 0)
    label.Position = UDim2.new(0, textOffset, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Button"
    label.TextColor3 = theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = btn

    if config.Description then
        label.Size = UDim2.new(1, -textOffset - 10, 0.45, 0)
        label.Position = UDim2.new(0, textOffset, 0.08, 0)
        label.Font = Enum.Font.GothamBold

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -textOffset - 10, 0.38, 0)
        sub.Position = UDim2.new(0, textOffset, 0.54, 0)
        sub.BackgroundTransparency = 1
        sub.Text = config.Description
        sub.TextColor3 = theme.TextDim
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 11
        sub.Parent = btn
    end

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = theme.Accent
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 22
    arrow.Parent = btn

    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tweenInfo, { BackgroundColor3 = lighten(theme.TopBar, 18) }):Play()
        TweenService:Create(arrow, tweenInfo, { Position = UDim2.new(1, -22, 0, 0) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, tweenInfo, { BackgroundColor3 = theme.TopBar }):Play()
        TweenService:Create(arrow, tweenInfo, { Position = UDim2.new(1, -28, 0, 0) }):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), { BackgroundColor3 = theme.Accent }):Play()
        TweenService:Create(label, TweenInfo.new(0.08), { TextColor3 = Color3.fromRGB(255,255,255) }):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = lighten(theme.TopBar, 18) }):Play()
        TweenService:Create(label, TweenInfo.new(0.15), { TextColor3 = theme.Text }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if config.Callback then config.Callback() end
    end)

    local buttonObj = {}
    function buttonObj:SetText(text) label.Text = text end
    function buttonObj:SetEnabled(enabled)
        btn.Active = enabled
        btn.BackgroundTransparency = enabled and 0 or 0.5
        label.TextTransparency     = enabled and 0 or 0.5
        arrow.TextTransparency     = enabled and 0 or 0.5
    end

    return buttonObj
end

return GuiLib
