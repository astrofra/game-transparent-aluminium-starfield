// Splash screen

Include("scriptlib/nad.nut")

class	SplashScreen
{

	sfx_boot	=	0
	logo_item	=	0
	logo_item_1	=	0

	sync		=	0

	sequence_started
				=	false

	function	OnSetup(scene)
	{
		print("SplashScreen::OnSetup()")
		sync = g_clock
		print("sync = " + sync)

		logo_item = SceneFindItem(scene, "logo_0")
		logo_item_1 = SceneFindItem(scene, "logo_1")

		ItemSetAlpha(logo_item, 0.0)
		ItemSetAlpha(logo_item_1, 0.0)
	}

	function	OnUpdate(scene)
	{
		if (!sequence_started && ((g_clock - sync) > SecToTick(Sec(1.0))))
		{
			sequence_started = true
			sync = g_clock
			
			g_audio.PlaySplashScreenSound()

			local	cmd_str = "toalpha 0,0;toalpha 0.25,1.0;nop 2;"

			for (local n = 0; n < 10; n++)
			{
				local	_alpha = (10.0 - n) * 0.1 
				_alpha += (Rand(-0.1, 0.1) * (10.0 - n) * 0.1)
				cmd_str += "toalpha 0.025," + _alpha.tostring() + ";"
				cmd_str += "toalpha 0.0125," + (_alpha * 1.10).tostring() + ";"
				cmd_str += "toalpha 0.025," + (_alpha * 0.85).tostring() + ";nop 0.05;"
			}

			cmd_str += "toalpha 2,0;"

			ItemSetCommandList(logo_item, cmd_str)
			ItemSetCommandList(logo_item_1, "nop 2;toalpha 0.25,1;nop 0.25;toalpha 1.5,0;")
		}

		if (sequence_started && ((g_clock - sync) > SecToTick(Sec(7.0))))
			g_script().GoToTitleScreen()
	}

}