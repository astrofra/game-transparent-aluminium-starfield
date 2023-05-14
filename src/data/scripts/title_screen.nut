// Title Screen

Include("scriptlib/nad.nut")

class	TitleScreen
{
	title_ui		= 0

	title_item		= 0
	title_rot		= 0
	title_scale		= 0

	boat_item		= 0
	boat_rot		= 0

	title_angle		= 0.0
	boat_angle		= 0.0

	anim_ease		= 0.0

	sea				= 0

	stars_0			= 0
	stars_rot_0		= 0

	stars_1			= 0
	stars_rot_1		= 0

	function	OnSetup(scene)
	{
		title_ui = TitleUI() 

		g_audio.PlayMusicTitle()

		stars_0 = SceneFindItem(scene, "stars_0")
		stars_rot_0 = ItemGetRotation(stars_0)

		stars_1 = SceneFindItem(scene, "stars_1")
		stars_rot_1 = ItemGetRotation(stars_1)

		title_item = SceneFindItem(scene, "title")
		title_scale = Vector(1,1,1)
	}

	function	OnUpdate(scene)
	{
		title_ui.Update()
		
		if (g_controller.start == true)
		{
			g_audio.StopMusic()
			g_script().GoToNextLevel()
		}

		stars_rot_0 += Vector(Deg(5.0), Deg(5.0), 0.0).Scale(g_dt_frame)
		ItemSetRotation(stars_0, stars_rot_0)

		stars_rot_1 += Vector(Deg(5.0), 0.0, Deg(5.0)).Scale(g_dt_frame * 2.0)
		ItemSetRotation(stars_1, stars_rot_1)

		ItemSetScale(title_item, title_scale)

		local _scale_factor = Rand(1.0 - 0.025,1.0 + 0.025)
		title_scale = title_scale.Lerp(0.25,Vector(_scale_factor,_scale_factor,_scale_factor))
	}

}