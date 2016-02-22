using UnityEngine;
using System.Collections;

public class PlayerAttack : MonoBehaviour {

    public int damage = 40;
    public float atkCooldown = 0.3f;
    public float range = 100f;
    //public static int atkMode = 0;
    public static int ammo = 5;

    float timer;
    Ray shootRay;
    RaycastHit shootHit;
    int shootableMask;
    LineRenderer line;
    float displayTimer = 0.3f;


    // Use this for initialization
    void Awake () {
        shootableMask = LayerMask.GetMask("Shootable");
        line = GetComponent<LineRenderer>();
    }
	
	// Update is called once per frame
	void Update () {
        timer += Time.deltaTime;

        if (Input.GetButton("Fire1") && timer >= atkCooldown && Time.timeScale != 0)
        {
            shoot();
        } else if (Input.GetButton("Fire2") && timer >= atkCooldown && Time.timeScale != 0)
        {
            shoot2();
        }

            if (timer >= atkCooldown * displayTimer)
        {
            line.enabled = false;
        }
    }

    void shoot()
    {
        timer = 0f;
        line.SetWidth(0.3f, 0.3f);
        line.enabled = true;
        line.SetPosition(0, transform.position);
        shootRay.origin = transform.position;
        shootRay.direction = transform.forward;

        if (Physics.Raycast(shootRay, out shootHit, range, shootableMask))
        {
            EnemyHealth enemyHealth = shootHit.collider.GetComponent<EnemyHealth>();
            if (enemyHealth != null)
            {
                enemyHealth.isDamaged(damage, shootHit.point); 
            }
            line.SetPosition(1, shootHit.point);
        }
        else
        {
            line.SetPosition(1, shootRay.origin + shootRay.direction * range);
        }
    }

    void shoot2()
    {
        if (ammo > 0)
        {
            ammo -= 1;
            int dam = 200;
            int range2 = 200;
            timer = 0f;
            line.SetWidth(0.2f, 5f);
            line.enabled = true;
            line.SetPosition(0, transform.position);
            shootRay.origin = transform.position;
            shootRay.direction = transform.forward;

            if (Physics.Raycast(shootRay, out shootHit, range2, shootableMask))
            {
                EnemyHealth enemyHealth = shootHit.collider.GetComponent<EnemyHealth>();
                if (enemyHealth != null)
                {
                    enemyHealth.isDamaged(dam, shootHit.point);
                }
                line.SetPosition(1, shootHit.point);
            }
            else
            {
                line.SetPosition(1, shootRay.origin + shootRay.direction * range2);
            }
        } else
        {
            return;
        }
        
    }
}
