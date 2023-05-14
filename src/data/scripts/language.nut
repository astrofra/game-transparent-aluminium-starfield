//

class	LanguageSelection
{

	controller		=	0
	selection_ui	=	0
	current_language
					=	0
	prv_current_language
					=	0
					
	language_list	=	["uk","jp","fr"]

	function	OnSetup(scene)
	{
		selection_ui = LanguageSelectionUI()
		
		controller = SimpleController()
		controller.Setup()
		controller.SetDirectionBounceFilter(true)
	}

	function	OnUpdate(scene)
	{
		controller.Update()
		
		if (controller.x < 0.0)
			current_language--
		else if (controller.x > 0.0)
			current_language++
			
		current_language = Mod(current_language, 3)		
		if (current_language != prv_current_language)
			selection_ui.SetCurrentLanguage(current_language)
		prv_current_language = current_language
		
		if ((controller.start == true) || (controller.shoot0 == true))
			ValidateLanguage()
	}
	
	function	ValidateLanguage()
	{
		g_current_language = language_list[current_language]
		Include("data/scripts/locale/" + g_current_language + ".nut")
		g_script().GoToSplashScreen()
	}
}