using UnityEngine;
using System.Collections;

public class Spawner : MonoBehaviour {
    public GameObject enemy;
    public float spawnTime = 3f;
    public Transform[] spawnPoints;

    // Use this for initialization
    void Start () {
        InvokeRepeating("Spawn", spawnTime, spawnTime);
    }
	
	// Update is called once per frame
	void Spawn () {
        int spawnPointIndex = Random.Range(0, spawnPoints.Length);

        Instantiate(enemy, spawnPoints[spawnPointIndex].position, spawnPoints[spawnPointIndex].rotation);
    }
}
