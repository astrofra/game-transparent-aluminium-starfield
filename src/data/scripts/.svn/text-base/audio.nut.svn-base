//

/*try
{	if (g_mute_sound == 1)
		print("AudioPlayer:: g_mute_sound = 1");	
}
catch(e)
{
	g_mute_sound <- 0;
	print("AudioPlayer:: g_mute_sound = 0");
}*/

g_mute_sound <- 0

class	AudioPlayer
{
	track				= 0
	
	sfx_info			= 0
	sfx_validate		= 0
	sfx_proceed			= 0
	sfx_error			= 0
	sfx_collision_0		= 0
	sfx_collision_1		= 0
	sfx_collision_2		= 0
	sfx_blow_up			= 0
	sfx_asteroid_explode_0	= 0
	sfx_asteroid_explode_1	= 0
	sfx_asteroid_explode_2	= 0
	sfx_asteroid_explode_3	= 0
	
	constructor()
	{
		track = {	
					music		= 0,
					ui			= 1
				} 
	}
	
	function	PlayerLoadSound(_filename)
	{
		local	_filepath = "data/sfx/" + _filename
		if (FileExists(_filepath))
		{
			print("AudioPlayer::PlayerLoadSound() loading '" + _filepath + "'.")
			return EngineLoadSound(g_engine, _filepath)
		}
		else
		{
			print("AudioPlayer::PlayerLoadSound() cannot find '" + _filepath + "' !!!")
			return 0
		}
	}
	
	function	Setup()
	{
		if (g_mute_sound) return
			
		//	Preload sounds
		sfx_validate 	= PlayerLoadSound("sfx_validate.wav")
		sfx_proceed		= PlayerLoadSound("sfx_proceed.wav")
		sfx_error		= PlayerLoadSound("sfx_error.wav")
		sfx_info		= PlayerLoadSound("sfx_info.wav")
		sfx_collision_0	= PlayerLoadSound("sfx_collision_0.wav")
		sfx_collision_1	= PlayerLoadSound("sfx_collision_1.wav")
		sfx_collision_2	= PlayerLoadSound("sfx_collision_2.wav")
		
		sfx_blow_up = PlayerLoadSound("sfx_blow_up.wav")
		
		sfx_asteroid_explode_0	= PlayerLoadSound("sfx_asteroid_explode_0.wav")
		sfx_asteroid_explode_1	= PlayerLoadSound("sfx_asteroid_explode_1.wav")
		sfx_asteroid_explode_2	= PlayerLoadSound("sfx_asteroid_explode_2.wav")
		sfx_asteroid_explode_3	= PlayerLoadSound("sfx_asteroid_explode_3.wav")

		//	Allocate channels
		//	Music Channel
		if (!MixerChannelTryLock(g_mixer, track.music))
			print("MusicPlayer::PlayerLoopStream() !! Cannot lock channel " + track.music)
		else
		{			
			MixerChannelSetLoopMode(g_mixer, track.music, LoopRepeat)
			MixerChannelSetGain(g_mixer, track.music, 1.0)
			MixerChannelSetPitch(g_mixer, track.music, 1.0)
		}
	
		//	UI message Channel
		if (!MixerChannelTryLock(g_mixer, track.ui))
			print("MusicPlayer::PlayerLoopStream() !! Cannot lock channel " + track.ui)
		else
		{			
			MixerChannelSetLoopMode(g_mixer, track.ui, LoopNone)
			MixerChannelSetGain(g_mixer, track.ui, 1.0)
			MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		}
	}

	function	PlaySplashScreenSound()
	{
		if (g_mute_sound) return
		PlayUIStream("data/sfx/sfx_splash_screen.ogg")
	}

	function	PlayBoatStream(_stream_file)
	{
		if (g_mute_sound) return
		//MixerChannelStop(g_mixer, track.boat)
		local _ch = MixerStreamStart(g_mixer, _stream_file) //MixerChannelStartStream(g_mixer, track.boat, _stream_file)
		MixerChannelSetPitch(g_mixer, _ch, Rand(0.7, 1.3))
		MixerChannelSetGain(g_mixer, _ch, Rand(0.9, 1.1))
	}
		
	function	PlayUIStream(_stream_file)
	{
		if (g_mute_sound) return
		MixerChannelStop(g_mixer, track.ui)
		MixerChannelStartStream(g_mixer, track.ui, _stream_file)
		MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		MixerChannelSetGain(g_mixer, track.ui, 0.25)
	}

	function	PlayCollisionSound()
	{
		if (g_mute_sound) return
		local	_snd
		switch (Mod(Irand(0,100),3))
		{
			case 0:
				_snd = sfx_collision_0
				break

			case 1:
				_snd = sfx_collision_1
				break

			case 2:
				_snd = sfx_collision_2
				break
		}

		MixerSoundStart(g_mixer, _snd)
	}
	
	function	PlayAsteroidExplosionSound()
	{
		if (g_mute_sound) return
		local	_snd
		switch (Mod(Irand(0,100),4))
		{
			case 0:
				_snd = sfx_asteroid_explode_0
				break

			case 1:
				_snd = sfx_asteroid_explode_1
				break

			case 2:
				_snd = sfx_asteroid_explode_2
				break
				
			case 3:
				_snd = sfx_asteroid_explode_3
				break
		}

		MixerSoundStart(g_mixer, _snd)
	}
	
	function	PlayEnemyExplosion()
	{ 		
		if (g_mute_sound) return
		MixerSoundStart(g_mixer, sfx_blow_up )	
	}

	function	PlayEnemyShoot()
	{	
		if (g_mute_sound) return
		MixerSoundStart(g_mixer, sfx_validate )
	}
	
	function	PlayUISound(_sound)
	{
		if (g_mute_sound) return
		MixerChannelStop(g_mixer, track.ui)
		MixerChannelStart(g_mixer, track.ui, _sound)
		MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		MixerChannelSetGain(g_mixer, track.ui, 0.25)
	}

	function	PlayMusicTitle()
	{
		if (g_mute_sound) return
		MixerChannelStop(g_mixer, track.music)
		MixerChannelStartStream(g_mixer, track.music, "data/sfx/track_00.ogg")
		MixerChannelSetLoopMode(g_mixer, track.music, LoopRepeat)
		MixerChannelSetPitch(g_mixer, track.music, 1.0)
		MixerChannelSetGain(g_mixer, track.music, 0.75)
	}
	
	function	PlayGameMusicLevel0()
	{
		if (g_mute_sound) return
		MixerChannelStop(g_mixer, track.music)
		MixerChannelStartStream(g_mixer, track.music, "data/sfx/track_01.ogg")
		MixerChannelSetLoopMode(g_mixer, track.music, LoopRepeat)
		MixerChannelSetPitch(g_mixer, track.music, 1.0)
		MixerChannelSetGain(g_mixer, track.music, 0.75)
	}

	function	StopMusic()
	{	
		if (g_mute_sound) return
		MixerChannelStop(g_mixer, track.music)	
	}

	
	function	UIInfo()
	{
		if (g_mute_sound) return
		PlayUISound(sfx_info)
	}
	
	
	function	UIValidate()
	{
		if (g_mute_sound) return
		PlayUISound(sfx_validate)
	}
	
	function	UIProceed()
	{
		if (g_mute_sound) return
		PlayUISound(sfx_proceed)
	}
	
	function	UIWarn()
	{
		if (g_mute_sound) return
		PlayUISound(sfx_proceed)
	}
}