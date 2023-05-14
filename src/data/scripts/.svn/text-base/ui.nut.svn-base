/* UI
*/

Include("data/scripts/locale/" + g_current_language + ".nut")

g_overscan_pad			<- 20.0

function	UICommonSetup()
{		
		UILoadFont ("data/ui/visitor1.ttf")
	
	    UISetSkin    (
                        g_ui, "data/ui/skin/t.tga", "data/ui/skin/l.tga", "data/ui/skin/r.tga", "data/ui/skin/b.tga",
                        "data/ui/skin/tl.tga", "data/ui/skin/tr.tga", "data/ui/skin/bl.tga", "data/ui/skin/br.tga", 0xff817100,
                        0xffffffff, 30, 20, 10, font.name
                    )
}

class	ShopUI
{
	_window		= 0
	_widget		= 0

	constructor()
	{
		UICommonSetup()

		//	Shop window
		_window = UIAddWindow(g_ui, -1, 1280.0 / 2.0, 960.0 / 2.25, 800.0, 600.0)
		WindowSetStyle(_window, StyleMovable)
		WindowSetTitle(_window, "")
		WindowCenterPivot(_window)
		//WindowShow(_window, false)
	}
}

//------------------
class	LevelIntroUI
//------------------
{
	_window		= 0
	_widget		= 0
	
	constructor()
	{
		UICommonSetup()
		
		//	Start menu window
		_window = UIAddWindow(g_ui, -1, 1280.0 / 2.0, 960.0 / 2.0, 800.0, 300.0)
		WindowSetStyle(_window, StyleMovable)
		WindowSetTitle(_window, "")
		WindowCenterPivot(_window)		
		WindowSetCommandList(_window, "hide;")
		
		//	Start menu widget
		local	hsizer = UIAddHorizontalSizerWidget(g_ui, -1);
		WindowSetBaseWidget(_window, hsizer);
		
		local	_title_name = g_script().GetCurrentLevelIntroTitle()
		_widget = UIAddStaticTextWidget(g_ui, -1, _title_name, font.name)
		TextSetParameters(_widget, { size = 80, align = "center", color = 0xffffffff })
		SizerAddWidget(hsizer, _widget)
	}
	
	function	FadeIn()
	{
		WindowSetCommandList(_window, "toalpha 0,0;show;toalpha 0.75,1;nop 2.0;toalpha 0.75,0;")
	}
}

//-------------
class	TitleUI
//-------------
{
	
	start_menu_window		= 0
	start_menu_widget		= 0
	
	constructor()
	{
		UICommonSetup()
		
		//	Start menu window
		start_menu_window = UIAddWindow(g_ui, -1, 1280.0 / 2.0, 960.0 - 150.0 - g_overscan_pad, 600.0, 200.0)
		WindowSetStyle(start_menu_window, StyleMovable)
		WindowSetTitle(start_menu_window, "")
		WindowCenterPivot(start_menu_window)
		
		WindowSetCommandList(start_menu_window, "loop;toalpha 2.0,0.5;nop 0.5;toalpha 2.0,1.0;nop 0.5;next;")
		
		//	Start menu widget
		local	hsizer = UIAddHorizontalSizerWidget(g_ui, -1);
		WindowSetBaseWidget(start_menu_window, hsizer);
		
		start_menu_widget = UIAddStaticTextWidget(g_ui, -1, locale.press_space, font.name)
		TextSetParameters(start_menu_widget, { size = 80, align = "center", color = 0xffffffff })
		SizerAddWidget(hsizer, start_menu_widget)
	}
	
	function	Update()
	{
		local	_sin = sin(DegreeToRadian(TickToSec(g_clock) * 360.0) * 0.25)
		local	_scale = 0.75 + 0.125 * _sin
		WindowSetScale(start_menu_window , _scale, _scale)
	}
	
	function	FadeOut()
	{
		UISetCommandList(g_ui, "nop 0.25;globalfade 1,0;nop 0.25;")
	}
}

//-------------------------
class	LanguageSelectionUI
//-------------------------
{
	flag_fr		=	0
	flag_jp		=	0
	flag_uk		=	0
	
	flag_sel	=	0	
	
	constructor()
	{
		flag_uk = UIAddBitmapWindow(g_ui, 1, "data/ui/flag_uk.jpg", 640.0 - 250.0, 480.0, 200.0, 120.0)
		WindowCenterPivot(flag_uk)
		
		flag_jp = UIAddBitmapWindow(g_ui, 1, "data/ui/flag_jp.jpg", 640.0, 480.0, 200.0, 120.0)
		WindowCenterPivot(flag_jp)
		
		flag_fr = UIAddBitmapWindow(g_ui, 1, "data/ui/flag_fr.jpg", 640.0 + 250.0, 480.0, 200.0, 120.0)
		WindowCenterPivot(flag_fr)
		
		flag_sel = UIAddBitmapWindow(g_ui, 1, "data/ui/flag_selector.tga", 640.0 - 250.0, 480.0, 250.0, 150.0)
		WindowCenterPivot(flag_sel)
		
		AnimateSelector()
	}
	
	function	AnimateSelector()
	{
		WindowSetOpacity(flag_sel, 1.0)
		WindowResetCommandList(flag_sel)
		WindowSetCommandList(flag_sel, "loop;toalpha 1,0;nop 0.25;toalpha 1,1;nop 0.25;next;")
	}
	
	function	SetCurrentLanguage(current_language)
	{
		WindowSetPosition(flag_sel, 640.0 + (current_language - 1.0) * 250.0, 480.0)
		AnimateSelector()
	}
}

//------------
class	GameUI
//------------
{
	scene_2d				= 0
	
	won_window				= 0
	won_widget				= 0
	
	constructor()
	{		
		print("GameUI::Setup()")
		
		UICommonSetup()
	}
	
	function	CreateWonWindow()
	{
		//	Start menu window
		won_window = UIAddWindow(g_ui, -1, 1280.0 / 2.0, 960.0 / 2.0, 600.0, 200.0)
		WindowSetStyle(won_window, StyleMovable)
		WindowSetTitle(won_window, "")
		WindowCenterPivot(won_window)
		
		//WindowSetCommandList(won_window, "toalpha 0,0;")
		
		//	Start menu widget
		local	hsizer = UIAddHorizontalSizerWidget(g_ui, -1);
		WindowSetBaseWidget(won_window, hsizer);
		
		won_widget = UIAddStaticTextWidget(g_ui, -1, locale.level_complete, font.name)
		TextSetParameters(won_widget, { size = 80, align = "center", color = 0xffffffff })
		SizerAddWidget(hsizer, won_widget)
	}

	function	Update()
	{
	}
}