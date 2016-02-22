using UnityEngine;
using System.Collections;

public class EnemyHealth : MonoBehaviour {

    public int maxHP = 100;
    public int currHP;
    public int scoreValue = 1;

    BoxCollider boxCollider;
    bool isDead;

    // Use this for initialization
    void Awake () {
        boxCollider = GetComponent<BoxCollider>();
        currHP = maxHP;
    }
	
	// Update is called once per frame
	void Update () {
	
	}

    public void isDamaged(int damage, Vector3 hp)
    { 
        if (isDead)
            return;

        currHP -= damage;

        if(currHP <= 0)
        {
            dies();
        }
    }

    void dies()
    {
        isDead = true;
        boxCollider.isTrigger = true;
        GetComponent<NavMeshAgent>().enabled = false;
        GetComponent<Rigidbody>().isKinematic = true;
        ScoreController.score += scoreValue;
        Destroy(gameObject, 0.1f);
    }
}
