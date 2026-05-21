#include <windows.h>
#include <lm.h>
#include <stdio.h>

#pragma comment(lib, "netapi32.lib")

int wmain()
{
    const wchar_t* username  = USERNAME;
    const wchar_t* password  = PASSWORD;
    const wchar_t* groupname = GROUPNAME;

    NET_API_STATUS status;

    if (wcslen(password) > 0)
    {
        USER_INFO_1 ui = {0};
        ui.usri1_name     = (LPWSTR)username;
        ui.usri1_password = (LPWSTR)password;
        ui.usri1_priv     = USER_PRIV_USER;
        ui.usri1_flags    = UF_NORMAL_ACCOUNT | UF_DONT_EXPIRE_PASSWD;

        DWORD dwError = 0;
        status = NetUserAdd(NULL, 1, (LPBYTE)&ui, &dwError);

        if (status != NERR_Success && status != NERR_UserExists)
            return 1;
    }
    else
    {
        LPBYTE buf = NULL;
        status = NetUserGetInfo(NULL, username, 0, &buf);
        if (buf) NetApiBufferFree(buf);

        if (status != NERR_Success)
            return 1;
    }

    LOCALGROUP_MEMBERS_INFO_3 mi = {0};
    mi.lgrmi3_domainandname = (LPWSTR)username;

    status = NetLocalGroupAddMembers(NULL, groupname, 3, (LPBYTE)&mi, 1);

    return (status == NERR_Success || status == ERROR_MEMBER_IN_ALIAS) ? 0 : 1;
}
