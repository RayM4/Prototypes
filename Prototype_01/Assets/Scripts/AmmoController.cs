using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class AmmoController : MonoBehaviour {

    Text text;
    // Use this for initialization
    void Awake()
    {
        text = GetComponent<Text>();
        //PlayerAttack.ammo = 0;
    }

    // Update is called once per frame
    void Update()
    {
        text.text = "Ammo: " + PlayerAttack.ammo;
    }
}
