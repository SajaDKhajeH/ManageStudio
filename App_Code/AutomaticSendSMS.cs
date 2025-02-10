using System;
using System.Collections.Generic;
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
        timer = new Timer(5000);
        timer.Elapsed += Timer_Elapsed;
        timer.Enabled = true;
        timer.Start();
    }

    private void Timer_Elapsed(object sender, ElapsedEventArgs e)
    {
        ExecuteTime += 5;
        //اگر 5 6 7 یا هفت ثانیه هم شد اجرا بشه
        //اطلاع رسانی نوبت ها
        if (ExecuteTime % 5 == 0)
        {
            //dbo.usp_Remind_Turn
        }
        //ماهگرد و تولد
        else if (ExecuteTime % 72000 == 0)
        {
            //dbo.usp_Remind_Lunar_A_BirthDate
        }
    }
}