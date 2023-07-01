#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <cstrike>

#define PLUGINNAME	"AMXX Parachute"
#define VERSION		"0.2.3"
#define AUTHOR		"KRoT@L"

new bool:has_parachute[33];
new para_ent[33];
new bool:had_parachute[33];
new bool:player_died[33];

public plugin_init()
{
	register_plugin( PLUGINNAME, VERSION, AUTHOR )
	
	
	register_logevent( "event_roundstart", 2, "0=World triggered", "1=Round_Start" )
	register_logevent( "event_roundend", 2, "0=World triggered", "1=Round_End" )
	register_event( "ResetHUD", "event_resethud", "be" )
	register_event( "DeathMsg", "death_event", "a" )
}

public plugin_precache()
{
	precache_model("models/parachute.mdl")
}

public client_connect(id)
{
	if(para_ent[id] > 0)
	{
		remove_entity(para_ent[id])
	}
	has_parachute[id] = false
	para_ent[id] = 0
}

public event_roundstart() {
	new MaxPlayers = get_maxplayers();
	for( new id; id < MaxPlayers; id++ ) {
		if( had_parachute[id] == true && player_died[id] == false ) {
			has_parachute[id] = true
		}
	}
	set_task( 0.0, "free_parachute" );
		
}

public event_roundend() {
	new MaxPlayers = get_maxplayers();
	for( new id; id < MaxPlayers; id++ ) {
		if( is_user_alive( id ) ) {
			if( has_parachute[id] == true ) {
				had_parachute[id] = true;
			}else{
				had_parachute[id] = false;
			}
			player_died[id] = false;

		}else {
			if(para_ent[id] > 0) {
				remove_entity(para_ent[id])
			}
			has_parachute[id] = false
			para_ent[id] = 0
			player_died[id] = true;
		}
	}
		
}

public event_resethud( id ) {
	if(para_ent[id] > 0)
	{
		remove_entity(para_ent[id])
	}
	has_parachute[id] = false
	para_ent[id] = 0
}

public death_event()
{
	new id = read_data(2)

	if(para_ent[id] > 0)
	{
		remove_entity(para_ent[id])
	}
	has_parachute[id] = false
	para_ent[id] = 0
	player_died[id] = true
}


public free_parachute() {
	new maxPlayers = get_maxplayers();

	for( new i = 1; i <= maxPlayers; i++ )
	{
		if( !is_user_connected( i ) ) return PLUGIN_CONTINUE
		
		has_parachute[i] = true
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}

public client_PreThink(id)
{

	if( !is_user_alive(id) )
	{
		return PLUGIN_CONTINUE
	}

	if( has_parachute[id] )
	{
		if (get_user_button(id) & IN_USE )
		{
			if ( !( get_entity_flags(id) & FL_ONGROUND ) )
			{
				new Float:velocity[3]
				entity_get_vector(id, EV_VEC_velocity, velocity)
				if(velocity[2] < 0)
				{
					if (para_ent[id] == 0)
					{
						para_ent[id] = create_entity("info_target")
						if (para_ent[id] > 0)
						{
							entity_set_model(para_ent[id], "models/parachute.mdl")
							entity_set_int(para_ent[id], EV_INT_movetype, MOVETYPE_FOLLOW)
							entity_set_edict(para_ent[id], EV_ENT_aiment, id)
						}
					}
					if (para_ent[id] > 0)
					{
						velocity[2] = (velocity[2] + 40.0 < -100) ? velocity[2] + 40.0 : -100.0
						entity_set_vector(id, EV_VEC_velocity, velocity)
						if (entity_get_float(para_ent[id], EV_FL_frame) < 0.0 || entity_get_float(para_ent[id], EV_FL_frame) > 254.0)
						{
							if (entity_get_int(para_ent[id], EV_INT_sequence) != 1)
							{
								entity_set_int(para_ent[id], EV_INT_sequence, 1)
							}
							entity_set_float(para_ent[id], EV_FL_frame, 0.0)
						}
						else 
						{
							entity_set_float(para_ent[id], EV_FL_frame, entity_get_float(para_ent[id], EV_FL_frame) + 1.0)
						}
					}
				}
				else
				{
					if (para_ent[id] > 0)
					{
						remove_entity(para_ent[id])
						para_ent[id] = 0
					}
				}
			}
			else
			{
				if (para_ent[id] > 0)
				{
					remove_entity(para_ent[id])
					para_ent[id] = 0
				}
			}
		}
		else if (get_user_oldbutton(id) & IN_USE)
		{
			if (para_ent[id] > 0)
			{
				remove_entity(para_ent[id])
				para_ent[id] = 0
			}
		}
	}
	
	return PLUGIN_CONTINUE
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1036\\ f0\\ fs16 \n\\ par }
*/
