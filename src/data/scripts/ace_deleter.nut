// Title Screen

Include("scriptlib/nad.nut")

class	CommandListDeleter
{
	scene			= 0
	item_list		= 0
	current_item	= 0
	
	constructor()
	{
		Clear()
	}
	
	function	RegisterItem(_item)
	{
		item_list.append(_item)
	}
	
	function	Clear()
	{
		item_list = []
	}
	
	function	Update()
	{
		local	items_to_keep = [],
				items_to_delete = []
				
		//print("CommandListDeleter::Update()")
		foreach(current_item in item_list)
		{
			if (ItemIsCommandListDone(current_item))
				items_to_delete.append(current_item)
			else
				items_to_keep.append(current_item)
		}
		
		foreach(current_item in items_to_delete)
			SceneDeleteItem(ItemGetScene(current_item), current_item)

		item_list = items_to_keep
	}
}