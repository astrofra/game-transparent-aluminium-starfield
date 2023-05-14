//	Main project script

g_current_language
				<-	"uk"

Include ("scriptlib/nad.nut")
Include ("data/scripts/enemy.nut")
Include ("data/scripts/audio.nut")
Include ("data/scripts/controller.nut")
Include ("data/scripts/ace_deleter.nut")
Include ("data/scripts/fx_functions.nut")
Include ("data/scripts/ui.nut")

g_debug							<-	true
g_renderer						<-	0
g_mixer							<-	0
g_audio							<-	0
g_project						<-	0
g_ui							<-	0
g_controller					<-	0

g_ace_deleter					<-	0

g_enemies_count					<-	0


g_debug							<-	false
                            	
g_project_state_play			<-	0
g_project_state_fadeout			<-	1

function	g_script()
{
	return (ProjectGetScriptInstance(g_project))
}

g_renderer = EngineGetRenderer(g_engine)
g_mixer = EngineGetMixer(g_engine)

class	MainProject
{
	
	scene_list 		= [	{	name = "Language selection",		nms = "data/language.nms"},
						{	name = "Splash Screen",				nms = "data/splash.nms"},
						{	name = "Game Title",				nms = "data/title.nms"},

						{	name = locale.levels[0],			nms = "data/level_intro.nms"},
						{	name = "Level #0",					nms = "data/game_lvl_0.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[1],			nms = "data/level_intro.nms"},
						{	name = "Level #1",					nms = "data/game_lvl_1.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[2],			nms = "data/level_intro.nms"},
						{	name = "Level #2",					nms = "data/game_lvl_2.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[3],			nms = "data/level_intro.nms"},
						{	name = "Level #3",					nms = "data/game_lvl_3.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[4],			nms = "data/level_intro.nms"},
						{	name = "Level #4",					nms = "data/game_lvl_4.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[5],			nms = "data/level_intro.nms"},
						{	name = "Level #5",					nms = "data/game_lvl_5.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[6],			nms = "data/level_intro.nms"},
						{	name = "Level #6",					nms = "data/game_lvl_6.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[7],			nms = "data/level_intro.nms"},
						{	name = "Level #7",					nms = "data/game_lvl_7.nms"},
						{	name = "Shop",						nms = "data/shop.nms"},

						{	name = locale.levels[8],			nms = "data/level_intro.nms"},
						{	name = "Level #8",					nms = "data/game_lvl_8.nms"}
					]

	current_scene	=	-1
	next_scene		=	0

	scene_2d		= 	0

	scene_3d		=	0
	scene_3d_instance
					=	0
					
	fx_timer		=	0.0
	
	state			=	0

	function	OnSetup(project)
	{
		g_project = project
		
		g_audio = AudioPlayer()
		g_audio.Setup()
		
		g_ace_deleter = CommandListDeleter()
		
		g_controller = SimpleController()
		g_controller.Setup()
		
		state = g_project_state_play
		fx_timer = 0.0
		
		//GoToLanguageSelection()
		//GoToSplashScreen()
		GoToTitleScreen()
		//GoToNextLevel()
	}
	
	function	GoToLanguageSelection()
	{	next_scene = 0	}	

	function	GoToSplashScreen()
	{	next_scene = 1	}

	function	GoToTitleScreen()
	{	next_scene = 2	}

	function	GoToNextLevel()
	{	
		if (current_scene < 3)
			next_scene = 3
		else
			next_scene++

		print("MainProject::GoToNextLevel() next_scene = " + next_scene)
	}
	
	function	GetCurrentLevelIntroTitle()
	{
		return (scene_list[current_scene].name)
	}

	function	OnUpdate(project)
	{

		g_controller.Update()

		switch	(state)
		{
			case g_project_state_play:
				if (next_scene != current_scene)
				{
					fx_timer = g_clock
					
					if (scene_2d != 0)
						UISetCommandList(g_ui, "globalfade 1.0,1.0;")

					state = g_project_state_fadeout
				}
				break
				
			case g_project_state_fadeout:
				if ((g_clock - fx_timer) > SecToTick(Sec(1.0)))
				{
					//	Unload previous scene
					if (current_scene != -1)
					{
						ProjectUnloadScene(g_project, scene_3d)
						current_scene = -1
					}
						
					if (scene_2d != 0)
					{
						ProjectUnloadScene(g_project, scene_2d)
						scene_2d = 0
					}
						
					//	Create Blank 2D layer
					scene_2d = ProjectInstantiateScene(g_project, "data/blank_ui.nms", ProjectInstantiateLayerFront)
					g_ui = ProjectSceneGetInstance(scene_2d)
					UISetCommandList(g_ui, "globalfade 0.0,1.0;")
		
					//	Load next scene
					current_scene = next_scene
					print("MainProject::OnUpdate() : Loading scene " + scene_list[current_scene].name)
					scene_3d = ProjectInstantiateScene(g_project, scene_list[current_scene].nms, ProjectInstantiateLayerBack)
					scene_3d_instance = ProjectSceneGetInstance(scene_3d)
		
					SceneSetup(scene_3d_instance)
					SceneReset(scene_3d_instance)
		
					// Setup all engine resources.
					EngineSetupResources(g_engine)
					
					UISetCommandList(g_ui, "globalfade 10.0,0.0;")

					state = g_project_state_play
				}
				break
		}

	}
}