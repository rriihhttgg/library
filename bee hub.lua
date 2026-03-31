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
