-- drop table if exists test_new_rule_fraud_order_low_pc1_di;
-- create table test_new_rule_fraud_order_low_pc1_di as 
WITH 
orig_table AS 
    (
        SELECT  a.* 
            ,   CASE WHEN a.order_note != '' OR  a.item_note_rm_allSpace != '' THEN 1 ELSE 0 END is_has_note 
            ,   i.item_note 
            ,   i.dish_id, g.dish_name, g.cate_l2_id, g.cate_l2_name, g.cate_l3_id, g.cate_l3_name
            ,   u.user_reg_time, u.user_reg_date
        FROM (
            SELECT  
                    c.grass_date
                ,   c.request_id
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["user_id"]') AS BIGINT)         AS shopee_user_id 
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["now_user_id"]') AS BIGINT)     AS now_user_id 
                ,   TRY_CAST(JSON_EXTRACT(b.attributes, '$["order_id"]')    AS BIGINT)     AS order_id 
                ,   JSON_EXTRACT(c.attributes, '$["item_info"]')                           AS item_array  
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["UserInfo"]["username"]')  AS VARCHAR) AS  username 
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["UserInfo"]["status"]')    AS VARCHAR) AS  user_status 
                ,   c.client_ip 
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"]["SecurityDeviceID"]') AS VARCHAR)    AS  deviceid 
                ,   c.event_timestamp
                ,   c.event_local_datetime
                ,   c.sync_event_hit_result
                ,   c.async_highest_priority_hit_strategy_id
                ,   c.sync_highest_priority_hit_strategy_id 
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["order_note"]') AS VARCHAR)    AS order_note
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["item_note_list"]') AS VARCHAR)    AS item_note_list
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["item_note_rm_allSpace"]') AS VARCHAR) AS item_note_rm_allSpace
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["item_note_phone_number_list"]') AS VARCHAR)   AS item_note_phone_number_list 
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["order_note_2_phone_number_list"]') AS VARCHAR)    AS order_note_2_phone_number_list 
                ,   TRY_CAST(JSON_EXTRACT(c.attributes,'$["fratio_order_block_now_userid_per_ip_l3d"]')  AS DOUBLE) AS fratio_order_block_now_userid_per_ip_l3d
                ,   TRY_CAST(JSON_EXTRACT(c.metrics, '$["i_countDistinct_now_userid_per_ip_l3d"]') AS DOUBLE) AS i_countDistinct_now_userid_per_ip_l3d
                ,   TRY_CAST(JSON_EXTRACT(c.metrics,'$["i_countDistinct_block_now_userid_per_ip_3days"]') AS DOUBLE) AS i_countDistinct_block_now_userid_per_ip_3days
                ,   FROM_UNIXTIME(TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"]["createtimemillis"]') AS BIGINT) / 1000) as deviceid_reg_time 

                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["delivery_address"]') AS VARCHAR)    AS  delivery_address
                -- ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["delivery_city"]') AS VARCHAR)       AS  delivery_city
                ,   CASE TRY_CAST(JSON_EXTRACT(c.attributes, '$["delivery_city"]') AS VARCHAR) 
                        WHEN 'TP. HCM'  THEN 'Ho Chi Minh City'
                        WHEN 'Hà Nội'   THEN 'Hanoi'
                        WHEN 'Đà Nẵng'  THEN 'Da Nang'
                        ELSE TRY_CAST(JSON_EXTRACT(c.attributes, '$["delivery_city"]') AS VARCHAR) 
                    END delivery_city

                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["IPInfo"]["City_IP"]') AS VARCHAR)     AS  IP_city
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"].device_ext_info["gpsModify"]') AS VARCHAR)    AS gpsModify
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"].device_ext_info["isSimCard"]') AS VARCHAR)    AS isSimCard
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"]["tags"]') AS VARCHAR)                         AS Device_tags
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"].device_ext_info["networktype"]') AS VARCHAR)  AS networktype
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"]["download_app_number"]') AS VARCHAR)          AS download_app_number
                ,   TRY_CAST(JSON_EXTRACT(c.entities, '$["DFPInfoSZ"]["osversion"]') AS VARCHAR) AS osversion

                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["restaurant_id"]') AS BIGINT)        AS restaurant_id
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["store_id"]') AS BIGINT)             AS store_id
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["item_info"]') AS VARCHAR)           AS item_info
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["geohash7_address"]') AS VARCHAR)    AS geohash7_address
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["geohash8_address"]') AS VARCHAR)    AS geohash8_address
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["geohash12_address"]') AS VARCHAR)   AS geohash12_address
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["latitude"]') AS DOUBLE) AS latitude
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["longitude"]') AS DOUBLE) AS longitude
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["delivery_phone"]') AS DOUBLE) AS tph
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["total_discount"]') AS DOUBLE) / 100000 AS total_discount
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["total_amount"]') AS DOUBLE) / 100000 AS total_amount
                ,   TRY_CAST(JSON_EXTRACT(c.attributes, '$["sub_total"]') AS DOUBLE) / 100000 AS sub_total

            FROM    
                    antifraud_region.dwd_evt_rule_engine_all_strategies_exec_log_hi__vn c 
            LEFT JOIN  
                    antifraud_region.dwd_evt_rule_engine_all_strategies_exec_log_hi__vn b 
                ON  TRY_CAST(JSON_EXTRACT(c.attributes, '$.now_user_id') AS BIGINT)  = TRY_CAST(JSON_EXTRACT(b.attributes, '$.now_user_id') AS BIGINT)
                AND TRY_CAST(JSON_EXTRACT(c.attributes, '$.restaurant_id') AS BIGINT)= TRY_CAST(JSON_EXTRACT(b.attributes, '$.restaurant_id') AS BIGINT) 
            WHERE   1=1
                AND c.event_id = 151        
                AND b.event_id = 153
                AND c.grass_region = 'VN'   
                AND b.grass_region = 'VN'
                AND TRY_CAST(JSON_EXTRACT(c.attributes, '$.service_type') AS INT) = 5    
                AND TRY_CAST(JSON_EXTRACT(b.attributes, '$.service_type') AS INT) = 5 
                AND b.event_timestamp - c.event_timestamp > 0   AND (b.event_timestamp - c.event_timestamp) / 1000000 < 10000 
                AND c.grass_date BETWEEN DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-30d")}') AND DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}') 
                AND b.grass_date BETWEEN DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-30d")}') AND DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}') 
                AND TRY_CAST(JSON_EXTRACT(c.attributes, '$["total_discount"]') AS BIGINT) / 100000 >= 40000
                AND TRY_CAST(JSON_EXTRACT(b.attributes, '$["total_discount"]') AS BIGINT) / 100000 >= 40000 
                
        ) a 
        CROSS JOIN UNNEST(
                CAST(item_array AS ARRAY(ROW("dish_id" BIGINT, "dish_amount" BIGINT, "item_note" VARCHAR, "dish_id_str" VARCHAR, "dish_amount_str" VARCHAR)))
        ) i (dish_id, dish_amount, item_note, dish_id_str, dish_amount_str) 
        LEFT JOIN (
                SELECT  DISTINCT 
                    dish_id, dish_name, cate_l2_id, cate_l2_name, cate_l3_id, cate_l3_name
                FROM    shopeefood.shopeefood_mart_dim_vn_dish_category_da 
                WHERE   1=1
                    AND dt = '${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}'
                    -- AND cate_l2_id IN (19,30)
        ) g ON i.dish_id = g.dish_id 
        LEFT JOIN (
                SELECT  DISTINCT now_uid, foody_uid, shopee_uid
                    ,   FROM_UNIXTIME(create_time-3600)         AS  user_reg_time   -- VN Timezone GMT+7
                    ,   DATE(FROM_UNIXTIME(create_time-3600))   AS  user_reg_date   -- VN Timezone GMT+7
                FROM
                    shopeefood.shopeefood_mart_cdm_dim_vn_buyer_now_buyer_da
                WHERE   dt = DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}')
            ) u ON a.now_user_id = u.now_uid 
    )
,raw_date AS
    (
        SELECT  grass_date
            ,   now_user_id
            ,   order_count
        FROM    
            (
                SELECT  grass_date
                    ,   now_user_id
                    ,   cate_l2_id
                    ,   cate_l2_name
                    ,   COUNT(DISTINCT CASE WHEN cate_l2_id = 30 THEN order_id END) cat30_order__count
                    ,   COUNT(DISTINCT CASE WHEN cate_l2_id = 19 THEN order_id END) cat19_order__count
                    ,   COUNT(DISTINCT order_id) order_count
                FROM    orig_table
                WHERE   1=1
                    -- AND cate_l2_id IN (19,30)   --  milk and beer 
                GROUP BY 1, 2, 3, 4
                HAVING  COUNT(DISTINCT order_id) >= 2
            )
        WHERE
                TRY_CAST(cat30_order__count AS DOUBLE) / TRY_CAST(order_count AS DOUBLE) >= 0.7
            OR  TRY_CAST(cat19_order__count AS DOUBLE) / TRY_CAST(order_count AS DOUBLE) >= 0.7
    )   
,window_table as 
    (
        SELECT
                now_user_id
            ,   grass_date
            ,   sum(order_count) over (partition by now_user_id order by grass_date range between interval '0' day preceding and interval '0' day following) as day_1_count
            ,   sum(order_count) over (partition by now_user_id order by grass_date range between interval '2' day preceding and interval '0' day following) as day_3_count
            ,   sum(order_count) over (partition by now_user_id order by grass_date range between interval '6' day preceding and interval '0' day following) as day_7_count
        FROM raw_date 
        WHERE   1=1
            AND grass_date = DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}')
    )   
,filter_list_lowpc1 as 
    (
        SELECT DISTINCT
                a.*
            ,   r.pc1_lifetime
            ,   r.pc1_l90d
            ,   date_format(from_unixtime(f.create_time), '%Y-%m-%d') as user_reg_date 
        from raw_date l
        INNER JOIN  vnfdbi_opsndrivers.shopeefood_fdbi_dws_vn__buyer_pc1_summary_tab__vn_di r   ON r.user_id        = l.now_user_id AND l.grass_date = r.grass_date
        LEFT JOIN   shopeefood.shopeefood_mart_cdm_dim_vn_buyer_now_buyer_da f                  ON f.now_uid        = l.now_user_id AND l.grass_date = r.grass_date
        INNER JOIN  window_table a                                                              ON l.now_user_id    = a.now_user_id AND a.grass_date = l.grass_date 
        WHERE   1=1
            AND r.pc1_l90d < (SELECT  APPROX_PERCENTILE(pc1_l90d, 0.005) FROM vnfdbi_opsndrivers.shopeefood_fdbi_dws_vn__buyer_pc1_summary_tab__vn_di WHERE grass_date = DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-1d")}'))
            AND r.pc1_lifetime < 0
            AND (
                    a.day_3_count > 7
                OR  a.day_1_count > 4
                OR  a.day_7_count > 10
            )
    )   

SELECT  o.*
    ,   CASE WHEN t.now_user_id IS NOT NULL THEN 1 ELSE 0 END is_rule_lowpc1
    ,   CASE 
            WHEN (
                        is_has_note = 1 
                    AND Device_tags IS NOT NULL 
                    AND (
                            DATE(o.deviceid_reg_time) <= DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-15d")}')
                        OR  o.user_reg_date <= DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-15d")}')
                    )
            )   THEN 1 
            WHEN (
                        is_has_note = 1 
                    AND o.delivery_city != IP_city
                    AND (
                            DATE(o.deviceid_reg_time) <= DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-15d")}')
                        OR  o.user_reg_date <= DATE('${bizTimeFormatter(BIZ_TIME,"yyyy-MM-dd","-15d")}')
                    )
            )   THEN 1 
            ELSE 0
        END is_rule_newuser
FROM 
    (
        SELECT   
                o.grass_date
            ,   o.request_id
            ,   o.shopee_user_id 
            ,   o.now_user_id 
            ,   o.order_id 
            -- ,   o.item_array  
            ,   o.username 
            ,   o.user_status 
            ,   o.client_ip 
            ,   o.deviceid 
            ,   o.event_timestamp

            ,   o.event_local_datetime
            ,   o.sync_event_hit_result
            ,   o.async_highest_priority_hit_strategy_id
            ,   o.sync_highest_priority_hit_strategy_id 
            ,   o.order_note
            ,   o.item_note_list
            ,   o.item_note_rm_allSpace
            ,   o.item_note_phone_number_list 
            ,   o.order_note_2_phone_number_list 
            ,   o.fratio_order_block_now_userid_per_ip_l3d

            ,   o.i_countDistinct_now_userid_per_ip_l3d
            ,   o.i_countDistinct_block_now_userid_per_ip_3days
            ,   o.deviceid_reg_time 
            ,   o.delivery_address
            ,   o.delivery_city
            ,   o.IP_city
            ,   o.gpsModify
            ,   o.isSimCard
            ,   o.Device_tags
            ,   o.networktype

            ,   o.download_app_number
            ,   o.osversion
            ,   o.restaurant_id
            ,   o.store_id
            ,   o.item_info
            ,   o.geohash7_address
            ,   o.geohash8_address
            ,   o.geohash12_address
            ,   o.latitude
            ,   o.longitude

            ,   o.tph
            ,   o.total_discount
            ,   o.total_amount
            ,   o.sub_total
            ,   o.is_has_note 
            ,   o.user_reg_time
            ,   o.user_reg_date  -- 47
            ,   ARRAY_AGG(o.dish_id)        agg_dish_id 
            ,   ARRAY_AGG(o.item_note)      agg_dish_note 
            ,   ARRAY_AGG(o.dish_name)      agg_dish_name 
            ,   ARRAY_AGG(o.cate_l2_id)     agg_cate_l2_id
            ,   ARRAY_AGG(o.cate_l2_name)   agg_cate_l2_name
        FROM    orig_table o 
        WHERE   1=1
            AND o.grass_date = CURRENT_DATE - INTERVAL '1' DAY
        GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
    ) o
LEFT JOIN filter_list_lowpc1 t ON t.now_user_id = o.now_user_id AND o.grass_date = t.grass_date
WHERE   1=1

