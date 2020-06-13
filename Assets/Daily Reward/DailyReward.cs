using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DailyReward : MonoBehaviour
{
    public Button[] rewardButton;
    public Text[] dayText;
    public Text[] claimText;
    private int currentDay;
    private TimeSpan startTime;
    private TimeSpan endTime;
    private TimeSpan remainingTime;
    public int hours;
    public int minutes;
    public int seconds;
    private bool timerIsReady;
    private bool timerComplete;
    private double value;
    public Text showTimer;

    void Start()
    {
        for (int i = 0; i < rewardButton.Length; i++)
        {
            rewardButton[i].interactable = false;
        }
        if (PlayerPrefs.GetString("Timer")=="")
        {
            Debug.Log("Reward Button is Enabled for First Time");
            currentDay = 0;
            PlayerPrefs.SetInt("CurrentDay",currentDay);
            EnableButton();
        }
        else
        {
            DisableButton();
            currentDay = PlayerPrefs.GetInt("CurrentDay");
            StartCoroutine(CheckTimer());
        }

        for (int i = 0; i < currentDay; i++)
        {
            dayText[i].enabled = false;
            claimText[i].enabled = true;
        }
    }

    private void Update()
    {
        if(timerIsReady)
        {
            if (!timerComplete && PlayerPrefs.GetString ("Timer") != "")
            {
                value -= Time.deltaTime;// * 1f / (float)endTime.TotalSeconds;
                Debug.Log("Calculating Remaining Time");
                int gameSeconds = (int) (value) % 60;
                int gameMinutes = (int) (value / 60) % 60;
                int gameHours = (int) (value / 3600) % 24;
                string timeString = string.Format("{0:00}:{1:00}:{2:00}", gameHours, gameMinutes, gameSeconds);
                showTimer.text = "Time Unity Next Reward: " + timeString;
                //this is called once only
                if (value <= 0 && !timerComplete)
                {
                    value = 0;
                    //when the timer hits 0, let do a quick validation to make sure no speed hacks.
                    StartCoroutine(CheckTimer());
                    timerComplete = true;
                }
            }
        }
    }

    private IEnumerator CheckTimer()
    {
        Debug.Log("Checking For Time Remaining for Upcoming Reward");
        yield return StartCoroutine(TimeManager.instance.GetTime());
        UpdateTimer();
    }

    private void UpdateTimer()
    {
        if (PlayerPrefs.GetString("Timer") == "StandBy")
        {
            Debug.Log("Setting New Timer For Next Reward");
            PlayerPrefs.SetString("Timer",TimeManager.instance.GetCurrentTime());
            PlayerPrefs.SetInt("Date",TimeManager.instance.GetCurrentDate());
        }

        ConfigTimerSettings();
    }

    private void ConfigTimerSettings()
    {
        startTime = TimeSpan.Parse(PlayerPrefs.GetString("Timer"));
        endTime = TimeSpan.Parse(hours + ":" + minutes + ":" + seconds);
        TimeSpan temp = TimeSpan.Parse(TimeManager.instance.GetCurrentTime());
        TimeSpan diff = temp.Subtract(startTime);
        remainingTime = endTime.Subtract(diff);
        
        if (diff >= endTime)
        {
            Debug.Log("New Reward is Ready");
            timerComplete = true;
            EnableButton();
            
        }
        else
        {
            Debug.Log("New Reward is not Ready");
            timerComplete = false;
            DisableButton();
            value = remainingTime.TotalSeconds;
            timerIsReady = true;
        }
    }
    private void EnableButton()
    {
        showTimer.text = "Reward Ready";
        rewardButton[currentDay].interactable = true;
    }

    private void DisableButton()
    {
        rewardButton[currentDay].interactable = false;
    }

    public void ProcessReward()
    {
        ClaimReward();
        PlayerPrefs.SetString("Timer","StandBy");
        SetNextButton();
    }

    private void ClaimReward()
    {
        Debug.Log("Player is Rewarded! Yaay");
        
    }

    private void SetNextButton()
    {
        Debug.Log("Making Next Button Ready for Clickable");
        DisableButton();
        dayText[currentDay].enabled = false;
        claimText[currentDay].enabled = true;
        currentDay++;
        if (currentDay == rewardButton.Length)
        {
            currentDay = 0;
            StartCoroutine(ResetReward());
        }
        PlayerPrefs.SetInt("CurrentDay",currentDay);
        StartCoroutine(CheckTimer());
    }

    private IEnumerator ResetReward()
    {
        yield return new WaitForSeconds(2f);
        for (int i = 0; i < rewardButton.Length; i++)
        {
            dayText[i].enabled = true;
            claimText[i].enabled = false;
        }
    }
}
