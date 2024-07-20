void StartVoteYesNo(int client)
{
	if (!IsValidClient(client))
		return;

	if (!L4D2NativeVote_IsAllowNewVote())
	{
		PrintToChat(client, "\x05%s \x04暂时不能开启新的投票", NEKOTAG);
		return;
	}

	char buffer[512], sbuffer[512];

	if (StrEqual(VoteMenuItems[client], "tgstat"))
	{
		Format(buffer, sizeof buffer, "多特插件");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgrandom"))
	{
		Format(buffer, sizeof buffer, "随机特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtanklive"))
	{
		Format(buffer, sizeof buffer, "坦克存活时刷新特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtime"))
	{
		Format(buffer, sizeof buffer, "刷特时间为");
		Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgnum"))
	{
		Format(buffer, sizeof buffer, "初始刷特数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgadd"))
	{
		Format(buffer, sizeof buffer, "进人增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpnum"))
	{
		Format(buffer, sizeof buffer, "初始玩家数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpadd"))
	{
		Format(buffer, sizeof buffer, "玩家增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgmode"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "游戏模式为");
	}
	if (StrEqual(VoteMenuItems[client], "tgspawn"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "刷特模式为");
	}

	L4D2NativeVote vote = L4D2NativeVote(VoteYesNoHandle);
	vote.Initiator		= client;
	vote.SetDisplayText("投票%s %s", buffer, sbuffer);

	int iCount	   = 0;
	int[] iClients = new int[MaxClients];

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(i))
		{
			if (GetClientTeam(i) == 2)
			{
				iClients[iCount++] = i;
			}
		}
	}

	if (!vote.DisplayVote(iClients, iCount, 15))
		LogError("%s 无法开始投票!", NEKOTAG);
}

public void VoteYesNoHandle(L4D2NativeVote vote, VoteAction action, int param1, int param2)
{
	switch (action)
	{
		case VoteAction_Start:
		{
			PrintToChatAll("\x05%s \x03%N \x04开始了一轮新的投票", NEKOTAG, param1);
		}

		case VoteAction_PlayerVoted:
		{
			PrintToChatAll("\x05%s \x03%N \x04投了 \x03%s", NEKOTAG, param1, param2 == VOTE_YES ? "确定" : "否决");
		}

		case VoteAction_End:
		{
			if (vote.YesCount > vote.PlayerCount * 0.8)
			{
				char buffer[512], sbuffer[512], item[512];
				int	 client = vote.Initiator;
				item		= VoteMenuItems[client];
				if (StrEqual(item, "tgstat"))
				{
					Format(buffer, sizeof buffer, "多特插件");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_PluginStatus].SetBool(!GCvar[CSpecial_PluginStatus].BoolValue);
				}
				if (StrEqual(item, "tgrandom"))
				{
					Format(buffer, sizeof buffer, "随机特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Random_Mode].SetBool(!GCvar[CSpecial_Random_Mode].BoolValue);
				}
				if (StrEqual(item, "tgtanklive"))
				{
					Format(buffer, sizeof buffer, "坦克存活时刷新特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Spawn_Tank_Alive].SetBool(!GCvar[CSpecial_Spawn_Tank_Alive].BoolValue);
				}
				if (StrEqual(item, "tgtime"))
				{
					Format(buffer, sizeof buffer, "刷特时间为");
					Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
					GCvar[CSpecial_Spawn_Time].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgnum"))
				{
					Format(buffer, sizeof buffer, "初始刷特数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_Num].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgadd"))
				{
					Format(buffer, sizeof buffer, "进人增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_AddNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpnum"))
				{
					Format(buffer, sizeof buffer, "初始玩家数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpadd"))
				{
					Format(buffer, sizeof buffer, "玩家增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerAdd].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgmode"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "游戏模式为");

					GCvar[CSpecial_Default_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					if (GCvar[CSpecial_Show_Tips].BoolValue)
						NekoSpecials_ShowSpecialsModeTips();

					if (GCvar[CSpecial_Random_Mode].BoolValue)
					{
						GCvar[CSpecial_Random_Mode].SetBool(false);
						PrintToChatAll("\x05%s \x04关闭了随机特感", NEKOTAG);
					}
				}
				if (StrEqual(item, "tgspawn"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "刷特模式为");

					GCvar[CSpecial_Spawn_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, sbuffer);
				}

				vote.SetPass("投票%s %s 通过!!!", buffer, sbuffer);

				cleanplayerchar(client);

				CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
			}
			else
			{
				vote.SetFail();
			}
		}
	}
}