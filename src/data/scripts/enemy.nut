// Enemy

g_alive		<-		0
g_explode	<-		1
g_dead		<-		2

function	GetGlobalPhase()
{	return (DegreeToRadian(TickToSec(g_clock)) * 60.0)	}

//-----------
class	Enemy
//-----------
{
	body					=	0
	pos						=	0
	vel						=	0.0

	scene					=	0
	bullet					=	0

	mass					=	0.0

	shield					=	0.0

	speed					=	1.0
	
	state					=	0

	//@PARM
	energy					=	1.0
	shoot_every_sec			=	Sec(1.0)
	dir_change_every_sec	=	Sec(3.0)	
	//@ENDPARM
	
	shoot_timer				=	0.0	
	dir_change_timer		=	0.0
	
	collision_timeout 		=	0.0

	damage_vfx_level 		=	0.0
	body_mat				=	0
	shield_item				=	0
	shield_mat				=	0
	self_illum				=	0

	dir				=	0
	new_dir			=	0

	current_target	=	0

	//-----------------------
	function	OnSetup(item)
	//-----------------------
	{
		body	=	item
		mass	=	ItemGetMass(body)
		energy	=	1.0
		pos		=	ItemGetPosition(body)
		vel		=	0.0
		
		print("Enemy::OnSetup() energy           = " + energy)
		print("Enemy::OnSetup() shoot_every      = " + shoot_every_sec + " Sec.")
		print("Enemy::OnSetup() dir_change_every = " + dir_change_every_sec + " Sec.")
		
		damage_vfx_level = 0.0

		scene	=	ItemGetScene(body)
		bullet	=	SceneFindItem(scene, "bullet")

		ItemSetOrientationMethod(body, OrientationMatrix)

		body_mat = GeometryGetMaterial(ItemGetGeometry(body), "body")
		self_illum = MaterialGetSelfIllum(body_mat)
		
		shield_item = SceneFindItemChild(scene, body, "shield")
		shield_mat = GeometryGetMaterial(ItemGetGeometry(shield_item), "shield")

		dir				=	Vector(0,0,0)
		new_dir			=	Vector(0,0,0)
		
		current_target = Vector(0,0,0)

		collision_timeout = g_clock
		shoot_timer = MutateValue(g_clock)
		dir_change_timer = MutateValue(g_clock)
		
		state			=	g_alive
	}
	
	//----------------------------------
	function	UpdateShieldFlickering()
	//----------------------------------
	{
		local	_s
		_s = (sin(GetGlobalPhase() * (4.0 + 16.0 * (1.0 - energy))))
		_s = _s * ((energy + 0.25) / 1.25)
		MaterialSetSelfIllum(shield_mat, Vector(_s,_s,_s))
	}

	//---------------------------------
	function	ResetCollisionTimeout()
	//---------------------------------
	{		collision_timeout = g_clock	}

	//-------------------------------------
	function	IsCollisionTimeoutElapsed()
	//-------------------------------------
	{
		if ((g_clock - collision_timeout) > SecToTick(Sec(0.125)))
			return true
		else
			return false
	}
	
	//------------------------------
	function	FindNewTargetPosition()
	//------------------------------
	{
		local	_tmp_list, target_list
		_tmp_list = SceneGetItemList(scene)
		target_list = []

		local	_item
		foreach(_item in _tmp_list)
		{
			if (ItemGetName(_item) == "asteroid")
			{
				target_list.append(_item)
				if (g_debug)
					RendererDrawLineColored(g_renderer, pos, ItemGetWorldPosition(_item), Vector(1,0.5,0,1))
			}
		}
		
		dir_change_timer = MutateValue(g_clock)

		if (target_list == [])
			return	Vector(0,0,0)

		local	_target_index = Mod(Irand(0, 999), target_list.len())
		print("Targeting asteroid #" + _target_index)
		local	_target = target_list[_target_index]

		return ItemGetWorldPosition(_target)
	}

	//--------------------------
	function	SetSelfIllum(_s)
	//--------------------------
	{	MaterialSetSelfIllum(body_mat, self_illum + Vector(_s,_s,_s))	}

	//------------------------
	function	OnUpdate(item)
	//------------------------
	{
		if (state == g_alive)
		{
			local	_phase
	
			if ((g_clock - dir_change_timer) > SecToTick(dir_change_every_sec))
				current_target = FindNewTargetPosition()
	
			ShipDirection()
			UpdateCannon()
			UpdateDamageVfx()
			UpdateShieldFlickering()
		}
		
		if (state == g_explode)
		{
			if (ItemIsCommandListDone(body))
				Die()
		}
		
		BorderTeleport()
		pos = ItemGetWorldPosition(body)
		vel = ItemGetLinearVelocity(body).Len()
	}

	function	DamageVfxFlash()
	{	damage_vfx_level = 5.0 }

	//--------------------------
	function	UpdateDamageVfx()
	//--------------------------
	{
		if (damage_vfx_level >= -0.1)
			SetSelfIllum(damage_vfx_level)

		damage_vfx_level = Clamp(damage_vfx_level - g_dt_frame * 10.0, 0.0, 1.0)
	}

	//----------------------------------------
	function	OnPhysicStep(item, step_taken)
	//----------------------------------------
	{
		if (!step_taken)
			return

		if (state == g_alive)
			ApplyThrust()
			
		KeepOnZPlane(body)
	}

	//----------------------
	function	ApplyThrust()
	//----------------------
	{
		dir = dir.Lerp(0.25, new_dir).Normalize()
		ItemApplyLinearForce(body, dir.Scale(mass * 15.0))
	}

	//-------------------------
	function	ShipDirection()
	//-------------------------
	{
		local	dir_to_asteroid,
				dir_ship, dir_thrust

		ItemComputeMatrix(body)

		dir_to_asteroid = (current_target - pos)
		dir_to_asteroid.z = 0.0
		dir_to_asteroid = dir_to_asteroid.Normalize()

		dir_ship = Vector(0.0,0.0,1.0).Cross(dir_to_asteroid)
		dir_ship.z = 0.0
		dir_ship = dir_ship.Normalize()
		
		dir_thrust = dir_to_asteroid.Lerp(0.5, dir_ship).Normalize()
		
		new_dir = dir_thrust

		if (g_debug)
		{
			RendererDrawLineColored(g_renderer, pos, pos + dir_to_asteroid.Scale(3.0), Vector(0,1,1,1))
			RendererDrawLineColored(g_renderer, pos, pos + dir_ship.Scale(3.0), Vector(1,0,1,1))
			RendererDrawLineColored(g_renderer, pos, pos + dir_thrust.Scale(3.0), Vector(1,1,0,1))
		}
		
		local _angle_to_target = dir_ship.AngleWithVector(dir_to_asteroid)
  	}

	//--------------------------------------
	function	OnCollision(item, with_item)
	//--------------------------------------
	{
		if (IsCollisionTimeoutElapsed())
		{
			ResetCollisionTimeout()

			local	with_item_name,
					asteroid_instance
			with_item_name = ItemGetName(with_item)
			asteroid_instance = ItemGetScriptInstance(with_item)
				
			if ((with_item_name == "asteroid") && (asteroid_instance.player))
			{
				//	Get asteroid velocity
				//	Velocity is supposed to range
				//	from 0 mtrs to 8 mtrs.
				local	_vel,
						_damage

				_vel = ItemGetLinearVelocity(with_item).Len()
				
				if (asteroid_instance.vel > 4.0)
				{
 					_damage	= 0.25
					TakeDamage(_damage)
				}
			}
			else
			{
				if (with_item_name == "enemy")
					current_target = FindNewTargetPosition()
			}
		}		 
	}

	//-----------------------------
	function	TakeDamage(_damage)
	//-----------------------------
	{
		energy -= _damage
		
		if (energy < 0.0)
			Explode()
		else
		{
			g_audio.PlayCollisionSound()
			DamageVfxFlash()
		} 
	}
	
	//-------------------
	function	Explode()
	//-------------------
	{
		state = g_explode
		FxCreateExplosion(scene, pos, 20.0)
		g_audio.PlayEnemyExplosion()
		ItemSetCommandList(body, "toalpha 0.25,0.0+toscale 0.25,5,5,5;")
		ItemSetCommandList(shield_item, "toalpha 0.25,0.0;")
	}
	
	//---------------
	function	Die()
	//---------------
	{
		state = g_dead
		g_enemy_manager.Dec()
		ItemSetCommandList(body, "nop 0.05;")
		g_ace_deleter.RegisterItem(body)
	}

	//---------------------------
	function	MutateValue(_val)
	//---------------------------
	{
		//_val = _val + _val * Rand(0.0, 0.1)
		return _val
	}
	
	//------------------------
	function	UpdateCannon()
	//------------------------
	{
		//print("Enemy::UpdateCannon() (g_clock - shoot_timer) = " + (g_clock - shoot_timer))

		if ((g_clock - shoot_timer) > SecToTick(shoot_every_sec))
		{
			shoot_timer = MutateValue(g_clock)
			Shoot()
		}
	}

	//-----------------
	function	Shoot()
	//-----------------
	{
		//print("Enemy::Shoot()")
		
		local	_new_bullet
		_new_bullet = SceneDuplicateItem(scene, bullet)

		g_audio.PlayEnemyShoot() 

		local	_origin = ItemGetWorldPosition(body)
		local	_aim = current_target //FindNewTargetPosition()
		local	_shoot_dir = _aim - _origin
		_shoot_dir = _shoot_dir.Normalize() //.Scale(200.0)

		ItemSetPosition(_new_bullet, _origin)
		ItemSetup(_new_bullet)

		ItemSetPhysicMode(_new_bullet, PhysicModeRigidBody)
		ItemWake(_new_bullet)

		//ItemApplyLinearForce(_new_bullet, _shoot_dir)
		ItemApplyLinearImpulse(_new_bullet, _shoot_dir.Scale(vel * 2.0))

		ItemSetCommandList(_new_bullet, "nop 5.0;")
		g_ace_deleter.RegisterItem(_new_bullet)
	}
 
}