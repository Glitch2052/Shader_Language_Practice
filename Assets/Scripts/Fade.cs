using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fade : MonoBehaviour
{
    private int Amount = Shader.PropertyToID("_Amount");
    private Renderer renderer;
    public float speed;

    void Start()
    {
        renderer = GetComponent<Renderer>();
    }
    
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            StartCoroutine(FadeSprite());
        }
        if (Input.GetKeyUp(KeyCode.Space))
        {
            StartCoroutine(FadeSprite1());
        }
    }

    IEnumerator FadeSprite()
    {
        float dx = 0;
        while (dx<=1.2)
        {
            renderer.material.SetFloat(Amount, dx);
            dx += Time.deltaTime*speed;
            yield return null;
        }
    }
    IEnumerator FadeSprite1()
    {
        float dx = 1;
        while (dx>=-0.2)
        {
            renderer.material.SetFloat(Amount, dx);
            dx -= Time.deltaTime*speed;
            yield return null;
        }
    }
}
