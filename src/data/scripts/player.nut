// Player

//--------------------------
function	BorderTeleport()
//--------------------------
{
	local	cam = SceneGetCurrentCamera(g_scene)

	if	(CameraCullObject(cam, ItemCastToObject(body)) != VisibilityInside)
	{
		local	_guardband = 0.1

		local	_teleport = false
		local	_velocity = ItemGetLinearVelocity(body)
		local _len = _velocity.Len()

		local	pos = ItemGetWorldPosition(body)
		local	sp = CameraWorldToScreen(cam, pos)

		if	((sp.x > 1.0) && (_velocity.x > 0.0))
		{
			sp.x -= 1.0 + (sp.x - 1.0) + _guardband
			_teleport = true
		}
		else	if	((sp.x < 0.0) && (_velocity.x < 0.0))
		{
			sp.x += 1.0 - sp.x + _guardband
			_teleport = true
		}

		if	((sp.y > 1.0) && (_velocity.y  < 0.0))
		{
			sp.y -= 1.0 + (sp.y - 1.0) + _guardband
			_teleport = true
		} 
		else	if	((sp.y < 0.0) && (_velocity.y > 0.0))
		{
			sp.y += 1.0 - sp.y + _guardband
			_teleport = true
		}

		if	(_teleport)
		{
			pos.z = Mtr(0.0)
			pos = CameraScreenToWorldPlane(cam, sp.x, sp.y, pos.z)
			local	scl = ItemGetScale(body)
			ItemPhysicResetTransformation(body, pos, ItemGetRotation(body))
			ItemSetScale(body, scl) 

			_velocity.z = 0.0
			_velocity = _velocity.Normalize(_len)

			ItemApplyLinearImpulse(body, _velocity)
		}
	}
}

//----------------------------
function	KeepOnZPlane(item)
//----------------------------
{
	local	v = ItemGetLinearVelocity(item)
	local	p = ItemGetWorldPosition(item)
 	local	i = Vector(0, 0, -p.z * 0.25)
	ItemApplyLinearImpulse(item, i)
}

//------------------
class	DeadAsteroid
//------------------
{
	split			= 0
	body			= 0
	scene			= 0
	pos				= 0
	vel_vector		= 0
	vel				= 0.0
	prev_vel		= 0.0
	asteroid_dock 	= 0
	mass			= 0
	diameter		= 0.0
	split_timeout	= 0.0
	player			= false

	//-----------------------		
	function	OnSetup(item)
	//-----------------------		
	{
		body = item
		pos	= ItemGetPosition(body)
		scene = ItemGetScene(body)
		asteroid_dock = SceneFindItem(scene, "asteroid_dock")
		print("DeadAsteroid::OnSetup()")
		mass = ItemGetMass(body)
		vel_vector = Vector(0,0,0)
		split_timeout = Sec(1.0)
		player = false

		print("split = " + split + ", mass = " + mass + " Kg, diameter = " + diameter + " Mtr.")
	}

	//-----------------------		
	function	OnUpdate(item)
	//-----------------------		
	{
		pos = ItemGetWorldPosition(body)
		prev_vel = vel
		vel_vector = ItemGetLinearVelocity(body)
		vel = vel_vector.Len()
		BorderTeleport()
		KeepOnZPlane(item)
		split_timeout -= g_dt_frame
	}

	//-----------------------------
	function	DeleteBullet(_item)
	//-----------------------------		
	{
			ItemSetCommandList(_item, "toalpha 0,0;nop 0.0075;toalpha 0,1;nop 0.0075;toalpha 0,0;nop 0.0075;toalpha 0,1;nop 0.0075;")
			g_ace_deleter.RegisterItem(_item)
	}
	
	//----------------------------------
	function	CreateExplosion(contact)
	//----------------------------------
	{
		local	_fx_size = RangeAdjust(split.tofloat(), 0.0, 6.0, 6.0, 2.0)
		_fx_size = Clamp(_fx_size, 2.0, 6.0).tointeger()
		FxCreateExplosion(scene, contact.p[0], _fx_size)
	}

	//------------------------------------------------
	function	EjectNewAsteroids(_list, contact, dir)
	//------------------------------------------------
	{
		local	_item
		foreach (_item in _list)
		{
			local	_ejection = contact.p[0]
			if (dir)
				_ejection = _ejection.Reverse()

			ItemApplyLinearForce(_item, _ejection * ItemGetMass(_item))
		}
	}

	//-------------------------------------------
	function	EjectHitAsteroid(item, with_item)
	//-------------------------------------------
	{
			local	_bullet_vel = ItemGetLinearVelocity(with_item)
			_bullet_vel.z = 0.0
			ItemApplyLinearForce(item, _bullet_vel * ItemGetMass(item))
	}

	//------------------------------------------------------
	function	OnCollisionEx(item, with_item, contact, dir)
	//------------------------------------------------------
	{
		if (split_timeout > 0.0)
			return
			
		if (ItemGetName(with_item) == "bullet")
		{
			// Spawn
			local 	_new_asteroids = SpawnHalves(contact, with_item),
					i, _asteroid

			//	Assign proper scripts
			foreach (i, _asteroid in _new_asteroids)
			{
				ItemSetScript(_asteroid, "data/scripts/player.nut", "DeadAsteroid")
				ItemSetupScript(_asteroid)
			}
			
			//	Audio feedback
			g_audio.PlayAsteroidExplosionSound()
			
			//	Create explosion
			CreateExplosion(contact)

			//	Eject the hit asteroids
			EjectHitAsteroid(item, with_item)

			//	Eject the newly created
			EjectNewAsteroids(_new_asteroids, contact, dir)

			//	Delete the bullet 
			DeleteBullet(with_item)
		}
	}

	//------------------------------
	function	SpawnHalves(contact, bullet_item)
	//------------------------------
	{
		if ((split < 0) || (split > 6))
			return []

		//	get mesh handle according to the split level
		local	_split = Min(split + 1, 6)
		local	_original_item = SceneFindItemChild(scene, asteroid_dock, "asteroid_" + _split)

		//	obtain two new spaws, half the size of the initial one		
		local	_new_asteroid,
				_asteroid_list = []

		for(local n = 0; n < 2; n++)
		{
			//	Spawn new objects in scene
			_new_asteroid = SceneDuplicateItem(scene, _original_item)
			ItemSetName(_new_asteroid, "asteroid")
			ItemSetup(_new_asteroid)
			local	_spawn_pos = pos
			local	_eject_vel
			_eject_vel =  (pos - ItemGetWorldPosition(bullet_item)).Normalize(ItemGetLinearVelocity(bullet_item).Len())
			ItemPhysicResetTransformation(_new_asteroid, _spawn_pos, Vector(0,0,0))
			ItemApplyLinearImpulse(_new_asteroid,_eject_vel)
			_asteroid_list.append(_new_asteroid)
		}

		//	finally delete the initial asteroid
		ItemSetCommandList(body, "toalpha 0,0;nop 0.0075;toalpha 0,1;nop 0.0075;toalpha 0,0;nop 0.0075;toalpha 0,1;nop 0.0075;")
		g_ace_deleter.RegisterItem(body)

		//	Can't explode twice
		split = -1

		return _asteroid_list
	}
}

//----------------------------------
class	Player extends DeadAsteroid
//----------------------------------
{

	target_pos		= 0
	init_pos		= 0
	speed			= Mtrs(5.0)
	inertia			= 0.65
	
	collision_timeout = 0.0

	trail			= 0
	record_every	= 0
	trail_length 	= 20

	//-----------------------
	function	OnSetup(item)
	//-----------------------
	{
		base.OnSetup(item)
		init_pos = pos
		target_pos = Vector(0,0,0)
		print("Player::OnSetup()")
		trail = []
		record_every = 0.0
		player = true
	} 

	//------------------------
	function	OnUpdate(item)
	//------------------------
	{
		base.OnUpdate(item)
		collision_timeout += g_dt_frame
		UpdateController()
		ItemApplyLinearForce(body, target_pos.Scale(mass * 100.0))
		RecordTrail()
		DrawTrail()
	}

	//-----------------------
	function	RecordTrail()
	//-----------------------
	{
		record_every += g_dt_frame

		if (record_every < Sec(0.05))
			return

		record_every = 0.0

		trail.insert(0, pos)
		if (trail.len() > trail_length)
			trail.remove(trail_length - 1)
	}

	//---------------------
	function	DrawTrail()
	//---------------------
	{
		local	_pos, i, _prev_pos,
				_fade = 1.0

		_prev_pos = pos

		foreach (i, _pos in trail)
		{
			if (_pos.Dist(_prev_pos) < Mtr(2.0))
			{
				_fade -= (1.0 / trail_length)
				_fade = Max(0.0, _fade)
				RendererDrawLineColored(g_renderer,_pos, _prev_pos, Vector(0,_fade * 0.5,_fade,1))
				_prev_pos = _pos
			}
		}
	}
	
	//------------------------------------------------------
	function	OnCollisionEx(item, with_item, contact, dir)
	//------------------------------------------------------
	{
		if (split_timeout > 0.0)
			return
			
		if (ItemGetName(with_item) == "bullet")
		{
			local 	_new_asteroids = base.SpawnHalves(contact, with_item),
					i, _asteroid

			foreach (i, _asteroid in _new_asteroids)
			{
				if (i == 0)
					ItemSetScript(_asteroid, "data/scripts/player.nut", "Player")
				else
					ItemSetScript(_asteroid, "data/scripts/player.nut", "DeadAsteroid")

				ItemSetupScript(_asteroid)
			}
			
			//	Audio feedback
			g_audio.PlayAsteroidExplosionSound()
			
			//	Create explosion
			base.CreateExplosion(contact)

			//	Eject the hit asteroids
			base.EjectHitAsteroid(item, with_item)

			//	Eject the newly created
			base.EjectNewAsteroids(_new_asteroids, contact, dir)

			//	Delete the bullet 
			base.DeleteBullet(with_item)
		}
	}

	//----------------------------
	function	UpdateController()
	//----------------------------
	{

		target_pos.x = g_controller.x * speed * g_dt_frame
		target_pos.y = g_controller.y * speed * g_dt_frame
		
		// PATCH
		if (g_controller.shoot0)
			g_script().GoToNextLevel()
	}

}