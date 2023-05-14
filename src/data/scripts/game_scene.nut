//	Game Scene

Include ("scriptlib/nad.nut")
Include ("data/scripts/controller.nut")

g_scene_intro	<-	0
g_scene_play	<-	1
g_scene_won		<-	2
g_scene_next	<-	3

g_enemy_manager	<-	0

//------------------
class	EnemyManager
//------------------
{
	enemy_count		=	0
	
	constructor()	{}
	
	function	Setup(scene)
	{	
		print("EnemyManager::Setup()")
		local	_item_list,
				_item
				
		_item_list = SceneGetItemList(scene)
		
		foreach(_item in _item_list)
		{
			local	_name = ItemGetName(_item)
			if (_name == "enemy")
				enemy_count++
		}
		
		print("EnemyManage::Setup() found enemy_count = " + enemy_count)
		
	}
	
	function	Inc()
	{	
		enemy_count++	
		print("EnemyManager::Inc() count = " + enemy_count) 
	}		
	
	function	Dec()
	{
		enemy_count--
		print("EnemyManager::Dec() count = " + enemy_count) 
	}
	
	function	AreAllEnemiesDead()
	{		return (enemy_count <= 0 ? true:false)	}
}

//---------------
class	GameScene
//---------------
{
	game_state			= 0	
	game_ui				= 0
	
	won_state_timer		= 0

	//------------------------
	function	OnSetup(scene)
	//------------------------
	{
		print("GameScene::OnSetup()")

		g_ace_deleter.Clear()

		g_audio.PlayGameMusicLevel0()
		game_ui = GameUI()
		g_controller.SetDirectionBounceFilter(false)
		
		g_enemy_manager = EnemyManager()
		g_enemy_manager.Setup(scene)
		
		if (EngineGetToolMode(g_engine) == NoTool)
			SceneSetCurrentCamera(scene, ItemCastToCamera(SceneFindItem(scene, "game_camera")))
			
		game_state = g_scene_play
	}

	//-------------------------
	function	OnUpdate(scene)
	//-------------------------
	{
		game_ui.Update()
		
		switch(game_state)
		{
			case	g_scene_play:
				g_ace_deleter.Update()
				if (g_enemy_manager.AreAllEnemiesDead())
				{
					game_state = g_scene_won
					won_state_timer = g_clock
					game_ui.CreateWonWindow()
				}
				break
				
			case	g_scene_won:
				if ((g_clock - won_state_timer) > SecToTick(Sec(5.0)))
					game_state = g_scene_next
				break
				
			case	g_scene_next:
				g_script().GoToNextLevel()
				break
		}
	}
}
