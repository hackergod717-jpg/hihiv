--========================================
-- LEADER HUB V5 (Light + Interactive)
-- Arabic | Mobile | Delta
--========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = "LEADER_HUB_V5"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

local parent = game:GetService("CoreGui")
pcall(function()
    parent = gethui()
end)
gui.Parent = parent

-- الثيمات: فاتح / داكن (الألوان الأساسية الحمراء والخضراء ثابتة)
local Themes = {
    light = {
        Background = Color3.fromRGB(226,231,246),
        Panel = Color3.fromRGB(250,251,255),
        Text = Color3.fromRGB(40,44,70),
        Outline = Color3.fromRGB(70,76,110),
        Idle = Color3.fromRGB(176,183,206),
        Track = Color3.fromRGB(205,211,232)
    },
    dark = {
        Background = Color3.fromRGB(35,36,48),
        Panel = Color3.fromRGB(58,59,72),
        Text = Color3.fromRGB(245,246,255),
        Outline = Color3.fromRGB(5,5,5),
        Idle = Color3.fromRGB(130,134,160),
        Track = Color3.fromRGB(30,31,42)
    }
}

local ThemeFile = "LeaderHubTheme.txt"
local themeName = "light"
pcall(function()
    if isfile(ThemeFile) and readfile(ThemeFile) == "dark" then
        themeName = "dark"
    end
end)

local C = {
    Red = Color3.fromRGB(220,35,40),
    Green = Color3.fromRGB(65,220,35),
    White = Color3.fromRGB(255,255,255),
    Amber = Color3.fromRGB(255,190,40),
    Ink = Color3.fromRGB(20,24,40) -- نص ثابت فوق الأزرار الخضراء
}
for k,v in pairs(Themes[themeName]) do
    C[k] = v
end

-- المابات التي طلبها المستخدم
-- تُحمّل الصور كأصول محلية عبر getcustomasset حتى تظهر داخل واجهة Delta.
local Maps = {
    {
        Name = "ماب سرقة البيض",
        ImageURL = "https://d.top4top.io/p_3922v5lak1.jpg",
        ImageFile = "LeaderHub_Map_EggSteal.jpg",
        Scripts = {
            {
                Name = "سينا هَب",
                URL = "https://senahub.xyz/senaexclusive"
            },
            {
                Name = "فلفل",
                URL = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"
            }
        }
    },
    {
        Name = "ماب كسر البيض",
        ImageURL = "https://j.top4top.io/p_3969zz9cf0.jpg",
        ImageFile = "LeaderHub_Map_EggBreak.jpg",
        Scripts = {
            {
                Name = "لينكس",
                URL = "https://raw.githubusercontent.com/4LynxX/Lynx/refs/heads/main/LynxxMain.lua"
            },
            {
                Name = "كسر وسرقة البيض تلقائياً",
                URL = "https://scriptblox.com/raw/Break-and-Steal-an-Egg-auto-break-auto-steal-instant-steal-auto-equip-233448"
            }
        }
    },
    {
        Name = "ماب بلوكس فروت",
        ImageURL = "https://f.top4top.io/p_3923xn5tv0.png",
        ImageFile = "LeaderHub_Map_BloxFruits.png",
        Scripts = {
            {
                Name = "تاي هَب بريميوم",
                URL = "https://raw.githubusercontent.com/VTDROBLOX/Animehub/refs/heads/main/Tayhub-PREMIUM.lua"
            },
            {
                Name = "جانتينغ هَب 2026",
                URL = "https://isnahamzah.site/SubscribeYTisnahamzah/Gantenghub2026_01"
            }
        }
    },
    {
        Name = "ماب أرمي الطعام للحيوانات",
        ImageURL = "https://l.top4top.io/p_3976bvz2l1.jpg",
        ImageFile = "LeaderHub_Map_ThrowFood.jpg",
        Scripts = {
            {
                Name = "رمي الطعام التلقائي",
                URL = "https://scriptblox.com/raw/Throw-Food-For-Animals-Auto-Throw-Always-Perfect-XENO-and-Solara-Support-KEYLESS-235175"
            },
            {
                Name = "رمي الطعام - جومانبا",
                URL = "https://raw.githubusercontent.com/gumanba/Scripts/main/ThrowFoodForAnimals"
            }
        }
    },
    {
        Name = "ماب كينغ ليغاسي",
        ImageURL = "https://d.top4top.io/p_3976bbnwj1.jpg",
        ImageFile = "LeaderHub_Map_KingLegacy.jpg",
        Scripts = {
            {
                Name = "أكوا هَب لكينغ ليغاسي",
                URL = "https://scriptblox.com/raw/UPD-11-PART-1-King-Legacy-AQUAHUB-or-AUTOFARM-AUTO-LEVEL-AUTO-EVENTS-236091"
            }
        }
    }
}

--========================================
-- المفضلة (تُحفظ في ملف)
--========================================
local FavFile = "LeaderHubFavs.json"
local Favs = {}

pcall(function()
    if isfile(FavFile) then
        local data = HttpService:JSONDecode(readfile(FavFile))
        if type(data) == "table" then Favs = data end
    end
end)

local function saveFavs()
    pcall(function()
        writefile(FavFile,HttpService:JSONEncode(Favs))
    end)
end

--========================================
-- Helpers
--========================================
local function corner(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

local function outline(obj,thick)
    local s = Instance.new("UIStroke")
    s.Color = C.Outline
    s.Thickness = thick or 2.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

-- UIGradient يُضرب في لون العنصر، لذلك نستخدم أبيض -> رمادي فاتح جداً
-- (الأعلى يبقى بنفس اللون الأصلي تماماً، والأسفل أغمق قليلاً فقط)
local function shine(obj,_,amount,rot)
    local a = math.clamp((amount or 0.18) * 0.5,0.03,0.12)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(
        Color3.new(1,1,1),
        Color3.new(1-a,1-a,1-a)
    )
    g.Rotation = rot or 90
    g.Parent = obj
    return g
end

-- للنصوص البيضاء فوق الألوان فقط
local function textOutline(lbl,t)
    lbl.TextStrokeColor3 = Color3.fromRGB(20,20,30)
    lbl.TextStrokeTransparency = t or 0.4
end

local function addScale(obj)
    local s = obj:FindFirstChildOfClass("UIScale")
    if s then return s end
    s = Instance.new("UIScale")
    s.Scale = 1
    s.Parent = obj
    return s
end

local function isPointer(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1
end

-- ضغط + تحويم
local function pressEffect(obj)
    local s = addScale(obj)
    local info = TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    local pressed = false
    obj.InputBegan:Connect(function(input)
        if isPointer(input) then
            pressed = true
            TweenService:Create(s,info,{Scale=0.92}):Play()
        end
    end)
    obj.InputEnded:Connect(function(input)
        if isPointer(input) then
            pressed = false
            TweenService:Create(s,info,{Scale=1}):Play()
        end
    end)
    obj.MouseEnter:Connect(function()
        if not pressed then TweenService:Create(s,info,{Scale=1.05}):Play() end
    end)
    obj.MouseLeave:Connect(function()
        pressed = false
        TweenService:Create(s,info,{Scale=1}):Play()
    end)
end

local function popIn(obj,index)
    local s = addScale(obj)
    s.Scale = 0.9
    task.delay((index-1)*0.04,function()
        if obj and obj.Parent then
            TweenService:Create(s,
                TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {Scale=1}):Play()
        end
    end)
end

--========================================
-- الفقاعة الصغيرة
--========================================
local bubble = Instance.new("ImageButton")
bubble.Parent = gui
bubble.Size = UDim2.fromOffset(46,46)
bubble.Position = UDim2.new(0,15,0.5,-23)
bubble.BackgroundTransparency = 1
bubble.BorderSizePixel = 0
bubble.Image = ""
bubble.ScaleType = Enum.ScaleType.Stretch
bubble.AutoButtonColor = false
bubble.ZIndex = 20
-- حواف ناعمة للفقاعة مع إبقاء الصورة كما هي
corner(bubble, 13)
local bubbleScale = addScale(bubble)

local BubbleURL = "https://f.top4top.io/p_3975f7x2d1.png"

task.spawn(function()
    local ok,err = pcall(function()
        local file = "LeaderBubble.png"
        if not isfile(file) then
            writefile(file,game:HttpGet(BubbleURL))
        end
        bubble.Image = getcustomasset(file)
    end)
    if not ok then warn("Bubble image:",err) end
end)

--========================================
-- النافذة الرئيسية
--========================================
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromOffset(330,455)
main.Position = UDim2.new(0.5,-165,0.5,-227)
main.BackgroundColor3 = C.Background
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
corner(main,9)
outline(main,3)
shine(main,C.Background,0.2)

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1,0,0,62)
header.BackgroundColor3 = C.Red
header.BorderSizePixel = 0
shine(header,C.Red,0.22)

local headerLine = Instance.new("Frame")
headerLine.Parent = header
headerLine.Size = UDim2.new(1,0,0,3)
headerLine.Position = UDim2.new(0,0,1,-3)
headerLine.BackgroundColor3 = C.Outline
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1,-155,0,38)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "قائمة المابات"
title.TextColor3 = C.White
title.TextSize = 19
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
textOutline(title,0.3)

local brandName = Instance.new("TextLabel")
brandName.Parent = header
brandName.Size = UDim2.fromOffset(120,26)
brandName.Position = UDim2.fromOffset(12,33)
brandName.BackgroundTransparency = 1
brandName.Text = "رمانة"
brandName.TextColor3 = C.White
brandName.TextSize = 21
brandName.Font = Enum.Font.GothamBlack
brandName.TextXAlignment = Enum.TextXAlignment.Left
textOutline(brandName,0.35)

local close = Instance.new("TextButton")
close.Parent = header
close.Size = UDim2.fromOffset(38,38)
close.Position = UDim2.new(1,-45,0,11)
close.BackgroundColor3 = C.Panel
close.Text = "X"
close.TextColor3 = C.Text
close.TextSize = 20
close.Font = Enum.Font.GothamBlack
close.AutoButtonColor = false
corner(close,6)
outline(close)
shine(close,C.Panel,0.1)
pressEffect(close)

-- تبديل الثيم (فاتح / داكن)
local themeBtn = Instance.new("TextButton")
themeBtn.Parent = header
themeBtn.Size = UDim2.fromOffset(38,38)
themeBtn.Position = UDim2.new(1,-135,0,11)
themeBtn.BackgroundColor3 = C.Panel
themeBtn.Text = (themeName == "dark") and "☀" or "🌙"
themeBtn.TextColor3 = C.Amber
themeBtn.TextSize = 20
themeBtn.Font = Enum.Font.GothamBlack
themeBtn.AutoButtonColor = false
corner(themeBtn,6)
outline(themeBtn)
shine(themeBtn,C.Panel,0.1)
pressEffect(themeBtn)

local infoBtn = Instance.new("TextButton")
infoBtn.Parent = header
infoBtn.Size = UDim2.fromOffset(38,38)
infoBtn.Position = UDim2.new(1,-90,0,11)
infoBtn.BackgroundColor3 = C.Panel
infoBtn.Text = "؟"
infoBtn.TextColor3 = C.Text
infoBtn.TextSize = 20
infoBtn.Font = Enum.Font.GothamBlack
infoBtn.AutoButtonColor = false
corner(infoBtn,6)
outline(infoBtn)
shine(infoBtn,C.Panel,0.1)
pressEffect(infoBtn)

local infoPanel = Instance.new("Frame")
infoPanel.Parent = main
infoPanel.Size = UDim2.fromOffset(286,116)
infoPanel.Position = UDim2.new(0.5,-143,0.5,-58)
infoPanel.BackgroundColor3 = C.Panel
infoPanel.BorderSizePixel = 0
infoPanel.Visible = false
infoPanel.ZIndex = 40
corner(infoPanel,10)
outline(infoPanel,2.5)

local infoText = Instance.new("TextLabel")
infoText.Parent = infoPanel
infoText.Size = UDim2.new(1,-20,1,-42)
infoText.Position = UDim2.fromOffset(10,7)
infoText.BackgroundTransparency = 1
infoText.Text = "تم صنع السكربت من قبل مطورين عرب\nحسابنا على تيك توك: كابتن طحبح\nنتمنى دعمكم ❤️"
infoText.TextColor3 = C.Text
infoText.TextSize = 14
infoText.Font = Enum.Font.GothamBold
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Center
infoText.TextYAlignment = Enum.TextYAlignment.Center
infoText.ZIndex = 41

local infoClose = Instance.new("TextButton")
infoClose.Parent = infoPanel
infoClose.Size = UDim2.new(1,-20,0,28)
infoClose.Position = UDim2.new(0,10,1,-34)
infoClose.BackgroundColor3 = C.Red
infoClose.Text = "إغلاق"
infoClose.TextColor3 = C.White
infoClose.TextSize = 14
infoClose.Font = Enum.Font.GothamBlack
infoClose.AutoButtonColor = false
infoClose.ZIndex = 41
corner(infoClose,6)
pressEffect(infoClose)
infoClose.MouseButton1Click:Connect(function()
    infoPanel.Visible = false
end)
infoBtn.MouseButton1Click:Connect(function()
    infoPanel.Visible = not infoPanel.Visible
end)

local themeBusy = false
-- يُعرَّف لاحقاً بعد إنشاء دوال العرض (يعيد بناء القوائم بالألوان الجديدة)
local themeHook = function() end

-- يغيّر كل العناصر الموجودة من ألوان الثيم القديم إلى الجديد
local function applyTheme(name)
    local new = Themes[name]
    local old = {}
    for k in pairs(new) do old[k] = C[k] end

    -- مقارنة بهامش صغير (بدل التطابق التام) لتفادي أخطاء الأرقام العشرية بعد الأنميشن
    local function mapColor(col)
        for k,v in pairs(old) do
            if math.abs(col.R - v.R) < 0.02
            and math.abs(col.G - v.G) < 0.02
            and math.abs(col.B - v.B) < 0.02 then
                return new[k]
            end
        end
        return nil
    end

    local info = TweenInfo.new(0.25)
    for _,o in ipairs(gui:GetDescendants()) do
        local goals = {}
        if o:IsA("GuiObject") then
            local m = mapColor(o.BackgroundColor3)
            if m then goals.BackgroundColor3 = m end
            if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
                local t = mapColor(o.TextColor3)
                if t then goals.TextColor3 = t end
            end
            if o:IsA("TextBox") then
                local p = mapColor(o.PlaceholderColor3)
                if p then goals.PlaceholderColor3 = p end
            end
        elseif o:IsA("UIStroke") then
            local s = mapColor(o.Color)
            if s then goals.Color = s end
        end
        if next(goals) then
            TweenService:Create(o,info,goals):Play()
        end
    end

    for k,v in pairs(new) do C[k] = v end
end

themeBtn.MouseButton1Click:Connect(function()
    if themeBusy then return end
    themeBusy = true

    themeName = (themeName == "dark") and "light" or "dark"
    applyTheme(themeName)
    themeHook()
    pcall(function() writefile(ThemeFile,themeName) end)

    themeBtn.Text = (themeName == "dark") and "☀" or "🌙"
    themeBtn.Rotation = 0
    local spin = TweenService:Create(themeBtn,
        TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Rotation = 360})
    spin:Play()
    spin.Completed:Connect(function()
        themeBtn.Rotation = 0
    end)

    task.delay(0.3,function() themeBusy = false end)
end)

-- شريط البحث
local searchBox = Instance.new("TextBox")
searchBox.Parent = main
searchBox.Position = UDim2.fromOffset(8,70)
searchBox.Size = UDim2.new(1,-16,0,34)
searchBox.BackgroundColor3 = C.Panel
searchBox.Text = ""
searchBox.PlaceholderText = "ابحث هنا..."
searchBox.PlaceholderColor3 = C.Idle
searchBox.TextColor3 = C.Text
searchBox.TextSize = 15
searchBox.Font = Enum.Font.GothamBold
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
corner(searchBox,7)
local searchStroke = outline(searchBox)

local searchPad = Instance.new("UIPadding")
searchPad.Parent = searchBox
searchPad.PaddingLeft = UDim.new(0,10)
searchPad.PaddingRight = UDim.new(0,10)

searchBox.Focused:Connect(function()
    TweenService:Create(searchStroke,TweenInfo.new(0.15),{Color=C.Green}):Play()
end)
searchBox.FocusLost:Connect(function()
    TweenService:Create(searchStroke,TweenInfo.new(0.15),{Color=C.Outline}):Play()
end)

-- أزرار التصفية (الكل / المفضلة)
local chips = Instance.new("Frame")
chips.Parent = main
chips.Position = UDim2.fromOffset(8,110)
chips.Size = UDim2.new(1,-16,0,28)
chips.BackgroundTransparency = 1

local chipsLayout = Instance.new("UIListLayout")
chipsLayout.Parent = chips
chipsLayout.FillDirection = Enum.FillDirection.Horizontal
chipsLayout.Padding = UDim.new(0,8)

local tab = "all"
local chipButtons = {}

local function makeChip(id,txt)
    local b = Instance.new("TextButton")
    b.Parent = chips
    b.Size = UDim2.new(0.5,-4,1,0)
    b.BackgroundColor3 = C.Panel
    b.Text = txt
    b.TextColor3 = C.Text
    b.TextSize = 14
    b.Font = Enum.Font.GothamBlack
    b.AutoButtonColor = false
    corner(b,7)
    outline(b,2)
    pressEffect(b)
    chipButtons[id] = b
    return b
end

local function refreshChips()
    for id,b in pairs(chipButtons) do
        TweenService:Create(b,TweenInfo.new(0.15),{
            BackgroundColor3 = (id == tab) and C.Green or C.Panel,
            TextColor3 = (id == tab) and C.Ink or C.Text
        }):Play()
    end
end

makeChip("all","الكل")
makeChip("fav","★ المفضلة")

-- قائمة المحتوى
local content = Instance.new("ScrollingFrame")
content.Parent = main
content.Position = UDim2.fromOffset(8,146)
content.Size = UDim2.new(1,-16,1,-154)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = C.Green
content.CanvasSize = UDim2.new()
content.ScrollingDirection = Enum.ScrollingDirection.Y

local pad = Instance.new("UIPadding")
pad.Parent = content
pad.PaddingTop = UDim.new(0,3)
pad.PaddingLeft = UDim.new(0,3)

local layout = Instance.new("UIListLayout")
layout.Parent = content
layout.Padding = UDim.new(0,9)
layout.SortOrder = Enum.SortOrder.LayoutOrder

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+18)
end)

local function setContentArea(showChips)
    chips.Visible = showChips
    if showChips then
        content.Position = UDim2.fromOffset(8,146)
        content.Size = UDim2.new(1,-16,1,-154)
    else
        content.Position = UDim2.fromOffset(8,110)
        content.Size = UDim2.new(1,-16,1,-118)
    end
end

local function clear()
    for _,v in ipairs(content:GetChildren()) do
        if v:IsA("GuiObject") then
            v:Destroy()
        end
    end
    content.CanvasPosition = Vector2.zero
end

local order = 0
local function nextOrder()
    order = order + 1
    return order
end

--========================================
-- إشعار صغير (Toast)
--========================================
local toast = Instance.new("Frame")
toast.Parent = main
toast.AnchorPoint = Vector2.new(0.5,1)
toast.Size = UDim2.fromOffset(230,34)
toast.Position = UDim2.new(0.5,0,1,50)
toast.BackgroundColor3 = C.Panel
toast.BorderSizePixel = 0
toast.ZIndex = 30
corner(toast,8)
outline(toast,2)

local toastLabel = Instance.new("TextLabel")
toastLabel.Parent = toast
toastLabel.Size = UDim2.new(1,-16,1,0)
toastLabel.Position = UDim2.fromOffset(8,0)
toastLabel.ZIndex = 31
toastLabel.BackgroundTransparency = 1
toastLabel.TextColor3 = C.Text
toastLabel.TextSize = 14
toastLabel.Font = Enum.Font.GothamBold
toastLabel.TextTruncate = Enum.TextTruncate.AtEnd
toastLabel.Text = ""

local toastToken = 0
local function notify(text)
    toastToken = toastToken + 1
    local my = toastToken
    toastLabel.Text = text
    TweenService:Create(toast,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Position = UDim2.new(0.5,0,1,-10)
    }):Play()
    task.delay(1.6,function()
        if my ~= toastToken then return end
        TweenService:Create(toast,TweenInfo.new(0.2),{
            Position = UDim2.new(0.5,0,1,50)
        }):Play()
    end)
end

--========================================
-- الأزرار والعرض
--========================================
local view = nil        -- nil = الرئيسية ، أو map
local query = ""
local render
local go

local function makeButton(txt,color,callback)
    local b = Instance.new("TextButton")
    b.Parent = content
    b.LayoutOrder = nextOrder()
    b.Size = UDim2.new(1,-10,0,46)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = C.Whit