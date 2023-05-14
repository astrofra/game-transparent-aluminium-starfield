

/*!
	@short	Item binding.
*/
class		Item
{
	handle			=	0;
	
	function		GetName()
	{	return ItemGetName(handle);	}

	function		GetPosition()
	{	return ItemGetPosition(handle);	}
	function		GetWorldPosition()
	{	return ItemGetWorldPosition(handle);	}
	function		SetPosition(p)
	{	ItemSetPosition(handle, p);	}	
	function		SetTarget(p)
	{	ItemSetTarget(handle, p);	}
	
	function		GetRotation()
	{	return ItemGetRotation(handle);	}
	function		SetRotation(r)
	{	ItemSetRotation(handle, r);	}
	
	function		GetScale()
	{	return ItemGetScale(handle);	}
	function		SetScale(s)
	{	ItemSetScale(handle, s);	}
	
	function		GetRotationMatrix()
	{	return ItemGetRotationMatrix(handle);	}

	function		GetMotion(id)
	{	return Motion(ItemGetMotion(handle, id));	}
	function		SetMotion(slot, motion, blend, weight, start, scale)
	{	ItemSetMotion(handle, slot, motion.GetHandle(), blend, weight, start, scale);	}
	function        StopMotion()
	{	ItemStopMotion(handle);	}
	function        MotionSlotStop(slot)
	{	ItemMotionSlotStop(handle, slot);	}

	function		Activate(active)
	{	ItemActivate(handle, active);	}
	function		ActivateHierarchy(active)
	{	ItemActivateHierarchy(handle, active);	}

	function		SetInvisible(invisible)
	{	ItemSetInvisible(handle, invisible);	}
	function		IsValid()
	{	return ItemIsValid(handle);	}

	function        GetAlpha()
	{	return ItemGetAlpha(handle);	}
	function        SetAlpha(alpha)
	{	ItemSetAlpha(handle, alpha);	}

	function		SetupScript()
	{	ItemSetupScript(handle);	}
	function		GetScriptInstance()
	{	return ItemGetScriptInstance(handle);	}

	function		SetCommandList(list)
	{	ItemSetCommandList(handle, list);	}
	function		IsCommandListDone()
	{	return ItemIsCommandListDone(handle);	}

	function		GetGeometry()
	{	return Geometry(ObjectGetGeometry(ItemCastToObject(handle)));	}
	function		SetGeometry(g)
	{	ObjectSetGeometry(ItemCastToObject(handle), g);	}

	function		SetGeometryFromFile(path)
	{	ObjectSetGeometry(ItemCastToObject(handle), EngineLoadGeometry(g_engine, path));	}
	
	function		CastToCamera()
	{	return Camera(ItemCastToCamera(handle));	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
