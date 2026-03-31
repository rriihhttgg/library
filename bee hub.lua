-- v0.0.2

-- GuiLib.lua
local GuiLib = {}
GuiLib.__index = GuiLib

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

-- =====================
--  Дефолтная тема
-- =====================
local DefaultTheme = {
    Background      = Color3.fromRGB(30, 30, 35),
    TopBar          = Color3.fromRGB(20, 20, 25),
    Accent          = Color3.fromRGB(100, 160, 255),
    Text            = Color3.fromRGB(240, 240, 240),
    TextDim         = Color3.fromRGB(160, 160, 170),
    Border          = Color3.fromRGB(55, 55, 65),
    CornerRadius    = UDim.new(0, 8),
    Transparency    = 0,
    BackgroundImage = "",
    ImageTransp     = 0,
}

-- =====================
--  Встроенные пресеты
-- =====================
GuiLib.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 35),
        TopBar     = Color3.fromRGB(20, 20, 25),
        Accent     = Color3.fromRGB(100, 160, 255),
        Border     = Color3.fromRGB(55, 55, 65),
    },
    Light = {
        Background = Color3.fromRGB(235, 235, 240),
        TopBar     = Color3.fromRGB(210, 210, 220),
        Accent     = Color3.fromRGB(60, 120, 220),
        Border     = Color3.fromRGB(180, 180, 190),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 20),
        TopBar     = Color3.fromRGB(5, 5, 15),
        Accent     = Color3.fromRGB(150, 80, 255),
        Border     = Color3.fromRGB(40, 40, 60),
    },
    Crimson = {
        Background = Color3.fromRGB(28, 15, 15),
        TopBar     = Color3.fromRGB(18, 8, 8),
        Accent     = Color3.fromRGB(220, 60, 60),
        Border     = Color3.fromRGB(70, 30, 30),
    },
    Forest = {
        Background = Color3.fromRGB(15, 28, 18),
        TopBar     = Color3.fromRGB(8, 18, 10),
        Accent     = Color3.fromRGB(60, 200, 100),
        Border     = Color3.fromRGB(30, 65, 38),
    },
    Ocean = {
        Background = Color3.fromRGB(12, 22, 35),
        TopBar     = Color3.fromRGB(7, 14, 25),
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
    frame.Size = UDim2.new(0, 420, 0, 500)
    frame.Position = UDim2.new(0.5, -210, 0.5, -250)
    frame.BackgroundColor3 = theme.Background
    frame.BackgroundTransparency = theme.Transparency
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    addCorner(frame)
    local frameStroke = addStroke(frame, theme.Border)

    -- Фоновая картинка
    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "BgImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = config.BackgroundImage or ""
    bgImage.ImageTransparency = (config.BackgroundImage and 0) or 1
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.Parent = frame
    addCorner(bgImage)

    -- Топбар
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
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
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -16)
    accent.Position = UDim2.new(0, 10, 0, 8)
    accent.BackgroundColor3 = theme.Accent
    accent.BorderSizePixel = 0
    accent.Parent = topBar
    addCorner(accent, UDim.new(1, 0))

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
    closeBtn.Position = UDim2.new(1, -38, 0, 5)
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

    -- Контент
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = theme.Accent
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = content

    -- Объект окна
    local window = setmetatable({}, GuiLib)
    window._frame     = frame
    window._topBar    = topBar
    window._patch     = patch
    window._accent    = accent
    window._bgImage   = bgImage
    window._stroke    = frameStroke
    window._content   = content
    window._theme     = theme
    window._titleLbl  = titleLabel
    window._scrollbar = content

    return window
end

-- =====================
--  :SetTheme(preset)
-- =====================
function GuiLib:SetTheme(presetName)
    local preset = GuiLib.Themes[presetName]
    assert(preset, "GuiLib: unknown theme '" .. tostring(presetName) .. "'")

    self._theme.Background = preset.Background
    self._theme.TopBar     = preset.TopBar
    self._theme.Accent     = preset.Accent
    self._theme.Border     = preset.Border

    self._frame.BackgroundColor3          = preset.Background
    self._topBar.BackgroundColor3         = preset.TopBar
    self._patch.BackgroundColor3          = preset.TopBar
    self._accent.BackgroundColor3         = preset.Accent
    self._stroke.Color                    = preset.Border
    self._scrollbar.ScrollBarImageColor3  = preset.Accent
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
        self._accent.BackgroundColor3                = color
        self._scrollbar.ScrollBarImageColor3         = color
    elseif key == "Border" then
        self._stroke.Color = color
    end
end

-- =====================
--  :SetTransparency(value)
-- =====================
function GuiLib:SetTransparency(value)
    assert(type(value) == "number", "GuiLib:SetTransparency — ожидается number (0–1)")
    value = math.clamp(value, 0, 1)
    self._theme.Transparency = value

    self._frame.BackgroundTransparency  = value
    self._topBar.BackgroundTransparency = value
    self._patch.BackgroundTransparency  = value
end

-- =====================
--  :SetBackgroundImage(assetId, transparency)
-- =====================
function GuiLib:SetBackgroundImage(assetId, transparency)
    self._bgImage.Image = assetId or ""
    self._bgImage.ImageTransparency = math.clamp(transparency or 0, 0, 1)
end

-- =====================
--  :RemoveBackgroundImage()
-- =====================
function GuiLib:RemoveBackgroundImage()
    self._bgImage.Image = ""
    self._bgImage.ImageTransparency = 1
end

-- =====================
--  :AddButton(config)
-- =====================
function GuiLib:AddButton(config)
    if type(config) == "string" then
        config = { Text = config }
    end
    config = config or {}

    local theme = self._theme

    -- Контейнер
    local container = Instance.new("Frame")
    container.Name = "ButtonContainer"
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundTransparency = 1
    container.Parent = self._content

    -- Кнопка
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = theme.TopBar
    btn.TextColor3 = theme.Text
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = container
    addCorner(btn)
    addStroke(btn, theme.Border)

    -- Акцентная полоска слева
    local leftBar = Instance.new("Frame")
    leftBar.Size = UDim2.new(0, 3, 0.6, 0)
    leftBar.Position = UDim2.new(0, 0, 0.2, 0)
    leftBar.BackgroundColor3 = theme.Accent
    leftBar.BorderSizePixel = 0
    leftBar.Parent = btn
    addCorner(leftBar, UDim.new(1, 0))

    -- Иконка
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = config.Icon or ""
    iconLabel.TextColor3 = theme.Accent
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Parent = btn

    -- Текст
    local textOffset = (config.Icon and 40) or 14
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

    -- Описание
    if config.Description then
        label.Size = UDim2.new(1, -textOffset - 10, 0.45, 0)
        label.Position = UDim2.new(0, textOffset, 0.08, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13

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

    -- Стрелка
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = theme.Accent
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 22
    arrow.Parent = btn

    -- Анимации
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function animateTo(bgColor, arrowOffset)
        TweenService:Create(btn, tweenInfo, { BackgroundColor3 = bgColor }):Play()
        TweenService:Create(arrow, tweenInfo, { Position = UDim2.new(1, arrowOffset, 0, 0) }):Play()
    end

    btn.MouseEnter:Connect(function()
        animateTo(lighten(theme.TopBar, 18), -22)
    end)
    btn.MouseLeave:Connect(function()
        animateTo(theme.TopBar, -28)
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

    -- Объект кнопки
    local buttonObj = {}

    function buttonObj:SetText(text)
        label.Text = text
    end

    function buttonObj:SetEnabled(enabled)
        btn.Active = enabled
        btn.BackgroundTransparency = enabled and 0 or 0.5
        label.TextTransparency     = enabled and 0 or 0.5
        arrow.TextTransparency     = enabled and 0 or 0.5
    end

    return buttonObj
end

return GuiLib
