#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

new const PLUGIN[]	= "HeadHunter";
new const VERSION[] 	= "1.1";
new const DATE[] 	= "7 January 2018";

const m_LastHitGroup = 75;

new g_hambot, cvar_huntmode;

enum
{
	disabled,	// 0
	headshot_only,	// 1
	no_headshot	// 2
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, "hellmonja");
	
	RegisterHam(Ham_TakeDamage, "player", "Fw_Damage");
	
	cvar_huntmode = register_cvar("hh_mode", "0", ADMIN_BAN);
	register_concmd("ver_hh", "Code_Version");
}

public Code_Version(id)
{
	console_print(id, "==============================");
	console_print(id, "%s v%s", PLUGIN, VERSION);
	console_print(id, "%s", DATE);
	console_print(id, "==============================");
}

public client_putinserver(id)
{
	if(!g_hambot && is_user_bot(id))
	{
		g_hambot = 1
		set_task(0.1, "Do_RegisterHam", id)
	}
}

public Do_RegisterHam(id)
{
	RegisterHamFromEntity(Ham_TakeDamage, id, "Fw_Damage");
}

public Fw_Damage(victim, inflictor, attacker, Float:dmg, dmgbits)
{
	switch(get_pcvar_num(cvar_huntmode))
	{
		case disabled:
			return HAM_HANDLED
		case headshot_only:
			if(get_pdata_int(victim, m_LastHitGroup) != HIT_HEAD) 
				return HAM_SUPERCEDE
		case no_headshot:
			if(get_pdata_int(victim, m_LastHitGroup) == HIT_HEAD) 
				return HAM_SUPERCEDE
	}
	
	return HAM_IGNORED
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
