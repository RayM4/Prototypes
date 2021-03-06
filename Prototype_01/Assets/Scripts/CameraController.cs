﻿using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour {

    public Transform target;
    public float smoothing = 5f;

    private Vector3 offset;

    // Use this for initialization
    void Start () {
        offset = transform.position - target.position;
    }
	
	// Update is called once per frame
	void Update () {
        Vector3 targetCamPos = target.position + offset;
        transform.position = Vector3.Lerp(transform.position, targetCamPos, smoothing * Time.deltaTime);
    }
}
