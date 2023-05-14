// Controller


class	SimpleController
{
	pad			= 0
	x			= 0.0
	y			= 0.0
	shoot0		= false
	start		= false

	constructor()
	{		}

	function	Setup()
	{
		/*
		local	device_list
		device_list	= GetDeviceList(DeviceTypeGame)

		if (device_list.len())
			pad = DeviceNew(device_list[0].id)
		*/
		
		print("Hack !!!! Paddle forcibly disabled")
		
		if (pad == 0)
		{
			KeyboardUpdate();
			KeyboardSetKeyBounceFilter(KeyLCtrl, true)
			KeyboardSetKeyBounceFilter(KeySpace, true)
		}
	}
	
	function	SetDirectionBounceFilter(_flag)
	{
		if	(pad == 0)
		{
			KeyboardSetKeyBounceFilter(KeyUpArrow, _flag)
			KeyboardSetKeyBounceFilter(KeyDownArrow, _flag)
			KeyboardSetKeyBounceFilter(KeyLeftArrow, _flag)
			KeyboardSetKeyBounceFilter(KeyRightArrow, _flag)
		}
	}
		
	//------------------------------
	function	Update()
	{	
		if	(pad != 0)
		{
			DeviceUpdate(pad);

			// Get pad throttle
			y = DevicePoolFunction(pad, DeviceAxisZ);
			y = (y - 32767.0) / -32767.0;

			// Get pad direction
			x = DevicePoolFunction(pad, DeviceAxisX);
			x = (x - 32767.0) / 32767.0; 
		}
		else
		{
			KeyboardUpdate();

			// Get keyboard throttle
			if (KeyboardSeekFunction(DeviceKeyPress, KeyUpArrow))
				y = 1.0;
			else
			{
				if (KeyboardSeekFunction(DeviceKeyPress, KeyDownArrow))
					y = -1.0;
				else
					y = 0.0;
			}

			// Get keyboard direction
			if (KeyboardSeekFunction(DeviceKeyPress, KeyLeftArrow))
				x = -1.0;
			else
			{
				if (KeyboardSeekFunction(DeviceKeyPress, KeyRightArrow))
					x = 1.0;
				else
					x = 0.0;
			}

			//	Get Keyboard Shoot #0
			if (KeyboardSeekFunction(DeviceKeyPress, KeyLCtrl))
				shoot0 = true;
			else
				shoot0 = false;

			//	Get Keyboard Start
			if (KeyboardSeekFunction(DeviceKeyPress, KeySpace))
				start = true;
			else
				start = false;
			
		}
	}
}