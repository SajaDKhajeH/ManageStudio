using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Timers;
using System.Web;
public class AutomaticSendSMS
{
    public static AutomaticSendSMS Instance = new AutomaticSendSMS();
    private AutomaticSendSMS()
    {

    }
    Timer timer;
    int ExecuteTime = 0;
    /// <summary>
    /// پیامک تولد و ماهگرد
    /// </summary>
    public void BeginSetSMS()
    {
        //هر 20 ساعت اجرا میشه
        timer = new Timer(10000);
        timer.Elapsed += Timer_Elapsed;
        timer.Enabled = true;
        timer.Start();
    }
    bool isWorking = false;
    private void Timer_Elapsed(object sender, ElapsedEventArgs e)
    {
        if (isWorking)
            return;
        isWorking = true;
        ExecuteTime += 10;
        var css = AdakDB.ConnectionStrings;
        foreach (var cs in css)
        {
            using (var db = AdakDB.GetDb(cs))
            {
                if (ExecuteTime % 10 == 0)
                {
                    db.usp_Remind_Turn();
                }
                else if (ExecuteTime % 72000 == 0)
                {
                    db.usp_Remind_Lunar_A_BirthDate();
                }
            }
        }
        isWorking = false;
    }
}