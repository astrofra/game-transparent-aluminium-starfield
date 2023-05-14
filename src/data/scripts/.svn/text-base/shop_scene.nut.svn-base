//	Game Scene

Include ("scriptlib/nad.nut")
Include ("data/scripts/controller.nut")

//---------------
class	ShopScene
//---------------
{

	shop_ui				= 0
	asteroids_handler	= 0
	asteroids_rotation	= 0

	//------------------------
	function	OnSetup(scene)
	//------------------------
	{
		print("ShopScene::OnSetup()")

		//g_ace_deleter.Clear()
		//shop_ui = ShopUI()
		//g_controller.SetDirectionBounceFilter(false)

		asteroids_handler = array(3,0)
		asteroids_rotation = array(3,0)

		for (local n = 0; n < 3; n++)
		{
			asteroids_handler[n] = SceneFindItem(scene, "asteroids_handler_" + n.tostring())
			asteroids_rotation[n] = ItemGetRotation(asteroids_handler[n])
		}
		
		SceneSetCurrentCamera(scene, ItemCastToCamera(SceneFindItem(scene, "game_camera")))
	}

	//-------------------------
	function	OnUpdate(scene)
	//-------------------------
	{
		if (shop_ui != 0)
			shop_ui.Update()
		RotateAsteroidsBelt()
	}

	//-------------------------------
	function	RotateAsteroidsBelt()
	//-------------------------------
	{
		for (local n = 0; n < 3; n++)
		{
			asteroids_rotation[n].z += DegreeToRadian(1.0 + n * 1.5) * g_dt_frame
			ItemSetRotation(asteroids_handler[n], asteroids_rotation[n])
		}
	}
}
