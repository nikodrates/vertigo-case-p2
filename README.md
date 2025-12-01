## Vertigo Games - Data Engineer Case Study v1.0 (Part 2: Data Pipeline & BI)

This repository contains the complete solution for the **Creating a DBT Model & Visualization** section (Part 2) of the Vertigo Games case study.

---

### 1. ENGINEERING ARCHITECTURE AND DBT METHODOLOGY

#### DBT Layering and Structure

The data flow utilizes explicit Staging and Marts layers to ensure clear separation of data cleansing from final business logic:

| Layer | Purpose | Files |
| :--- | :--- | :--- |
| **Staging (View)** | Reads raw data, handles base cleansing, type casting, and column selection to prepare the data for aggregation. | `stg_daily_activity.sql` |
| **Marts (Table)** | Contains the final aggregated business logic and KPI calculations (e.g., DAU, ARPDAU, Win Ratio). | `daily_metrics.sql` |

#### Data Quality and Robustness

* **Division by Zero Handling (Robustness):** All ratio calculations (ARPDAU, Win Ratio, etc.) utilize **`NULLIF(denominator, 0)`** logic within the SQL. This is a crucial production safeguard that prevents pipeline failure and ensures metrics are calculated correctly even when the denominator is zero.
* **Data Integrity Testing:** The `schema.yml` file includes custom tests to guarantee logical data validity:
    * A custom `dbt_utils.expression_is_true` test explicitly verifies that the **`win_ratio` remains within the acceptable range of 0 and 1**, eliminating illogical data points.

---

### 2. KEY FINDINGS AND VISUALIZATION

The final `marts.daily_metrics` table in BigQuery was connected to **Looker Studio** to produce the required business intelligence dashboard.

#### Dashboard Screenshots



<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 38 52" src="https://github.com/user-attachments/assets/c7d8a96c-0dc9-4cdb-9b88-fc489792d270" />
<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 35 39" src="https://github.com/user-attachments/assets/4d33d249-1936-4868-8de2-3406cd495073" />
<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 30 30" src="https://github.com/user-attachments/assets/c2a7a7aa-3328-46fd-9fff-81d9f7264e16" />
<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 28 12" src="https://github.com/user-attachments/assets/f8b276a3-01fd-4c9a-8e24-89a0fb814ee8" />
<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 27 46" src="https://github.com/user-attachments/assets/1c961efc-23ea-4c20-8d5d-39e49717c545" />
<img width="1000" height="500" alt="Screenshot 2025-12-01 at 04 25 05" src="https://github.com/user-attachments/assets/08734c9a-0542-430e-aa00-e6462b074d82" />




#### Core Business Insights Derived from Data

| Insight | Metric Support | Strategic Implication |
| :--- | :--- | :--- |
| **High-Value Markets** | The **United States (US) generates the highest total revenue**. | **Prioritize monetization strategies** and high-ARPDAU marketing efforts in the US and other Tier 1 regions, regardless of higher user volume elsewhere. |
| **Platform Volume** | The **ANDROID platform consistently maintains a higher volume of Daily Active Users (DAU)** than iOS. | Platform development and testing efforts should lean towards the Android platform to ensure quality for the majority of the user base. |
| **Revenue Source** | **In-App Purchase (IAP) Revenue is the dominant revenue stream**, significantly outweighing Ad Revenue. | The game's economy is successfully built on core IAP sales; optimization focus should remain on the IAP catalog and player retention. |
| **Game Balance** | The average **Win Ratio is stable at approximately 60-65%** across the period. | This indicates a healthy, balanced competitive environment that supports long-term player engagement. |

---

### 3. DEPLOYMENT AND DELIVERABLES

#### Deployment Automation

The pipeline is executed using a **Cloud Build trigger** that utilizes the `cloudbuild.yaml` file to orchestrate the process:

1.  **Build & Push:** Build the Docker image defined in `analytics_project/Dockerfile` and push it to Artifact Registry.
2.  **Transformation:** The `cloudbuild.yaml` script executes the necessary `dbt run` and `dbt test` commands within the container.
3.  **Authentication:** The `profiles.yml` file uses **`method: oauth`** and environment variables to ensure secure and seamless BigQuery connection.
