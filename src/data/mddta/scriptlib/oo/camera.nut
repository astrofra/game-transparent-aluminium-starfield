

/*!
	@short	Camera binding.
*/
class		Camera	extends	ItemDerived
{
	handle			=	0;

	function		GetItem()
	{	return Item(CameraGetItem(handle));	}

	function		SetAspectRatio(ar)
	{	CameraSetAspectRatio(handle, ar);	}
	function		GetAspectRatio(ar)
	{	return CameraGetAspectRatio(handle);	}
	function		SetAspectRatioVertical(bv)
	{	CameraSetAspectRatioRefAxis(handle, bv);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
