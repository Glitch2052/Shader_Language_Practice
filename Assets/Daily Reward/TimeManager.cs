using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class TimeManager : MonoBehaviour
{
    public static TimeManager instance;
    private string URL="www.Google.com";
    private string dateTime;
    private string currentTime;
    private string currentDate;
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else if(instance!=this)
        {
            Destroy(gameObject);
        }
        DontDestroyOnLoad(gameObject);
    }

    private void Start()
    {
        StartCoroutine(GetTime());
    }

    public IEnumerator GetTime()
    {
        UnityWebRequest www = new UnityWebRequest(URL);
        yield return www;
        if (www.error!=null)
        {
            Debug.Log("Error");
        }
        else
        {
            Debug.Log("Got the Info");
        }
        dateTime = DateTime.Now.ToString();
        Debug.Log(dateTime);
        string[] words = dateTime.Split(' ');
        currentDate = words[0];
        currentTime = words[1];
    }

    public string GetCurrentTime()
    {
        return currentTime;
    }

    public int GetCurrentDate()
    {
        string[] words = currentDate.Split('-');
        return int.Parse(words[0] + words[1] + words[2]);
    }
}
