//

class	LevelIntro
{
	
	intro_ui	= 0
	
	timeout		= 0.0
	
	text_shown	= false
	
	intro_done	= false

	function	OnSetup(scene)
	{
		print("LevelIntro::OnSetup()")
		timeout = g_clock
		intro_ui = LevelIntroUI()
		intro_done	= false
	}

	function	OnUpdate(scene)
	{
		local	_sync = TickToSec(g_clock - timeout)
		
		if ((!text_shown) && (_sync > Sec(0.125)))
		{
			intro_ui.FadeIn()
			text_shown = true
		}
		
		
		if (!intro_done && (_sync > Sec(4.0)))
		{
			g_script().GoToNextLevel()
			intro_done = true
		}
		
	}
}