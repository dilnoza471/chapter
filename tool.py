
@tool
def sql_get_monthly_loan_issuance_by_branch():
    """
    Use this SQL agent tool only when the user requests analysis or visualization
    of loan issuance amounts broken down by month and branch.

    ✅ Valid request examples:
    - "Show total loan issuance by branch and month"
    - "Which branch issued the most loans in March?"
    - "Compare loan issuance between Tashkent and Samarkand branches"
    - "Find the month with the highest total loan issuance"
    - "Show total yearly loan issuance for each branch"
    - "Which branch had the lowest issuance this year?"

    ⚠️ Do NOT use this tool for:
    - Year-over-year comparisons (use multi-year analysis tool)
    - Card or deposit data (use corresponding financial tools)
    - Predictions or forecasts (use ML-based prediction tool)

    --- PURPOSE ---
    This tool retrieves loan issuance data grouped by month and branch (Filial),
    pivoted into columns representing months.  
    It also computes each branch’s total issuance across all months for the year.

    --- OUTPUT EXPECTATION ---
    Return a summary table (and optionally a chart) showing total credit issuance
    for each branch across all months of the current year.

    Example output:

        Total Loan Issuance by Branch and Month (2025)
        | Branch (Filial) | January | February | March | ... | October | Total |
        |-----------------|----------|-----------|--------|-----|----------|--------|
        | Tashkent        | 12,400,000 UZS | 15,800,000 UZS | 14,600,000 UZS | ... | 17,300,000 UZS | 158,400,000 UZS |
        | Samarkand       | 10,900,000 UZS | 11,200,000 UZS | 13,500,000 UZS | ... | 12,800,000 UZS | 128,600,000 UZS |
        | ...             | ... | ... | ... | ... | ... | ... |

    --- SUPPORTED ANALYSES ---
    - Identify the branch with maximum or minimum total issuance
    - Identify the month with highest or lowest issuance
    - Compare issuance between two or more branches
    - Compare issuance between two specific months
    - Compute total loan issuance for the whole year
    - Display top N branches by total issuance

    --- LANGUAGE RULES ---
    - Always respond in the same language the user used.
    - Do not mix languages within a single response.

    --- CURRENCY RULES ---
    - Display all monetary values in UZS (Uzbek soum) only.
    - Always append “UZS” explicitly (e.g., 72,600,000 UZS).
    - Never convert or mention other currencies.

    --- BEHAVIOR NOTE ---
    - This tool must only be invoked for branch-level or monthly loan issuance analysis.
    - It automatically filters data for the current year and top 10 branches.
    - It can be followed by analytical queries (e.g., max/min/month comparisons)
      based on the returned dataset.
    """

    print("From sql_get_total_loan_issuance_by_month")

    query = """
        SELECT TOP (10)
            Filial,
            January,
            February,
            March,
            April,
            May,
            June,
            July,
            August,
            September,
            October,
            (ISNULL(January, 0) + ISNULL(February, 0) + ISNULL(March, 0) + 
             ISNULL(April, 0) + ISNULL(May, 0) + ISNULL(June, 0) + 
             ISNULL(July, 0) + ISNULL(August, 0) + ISNULL(September, 0) + 
             ISNULL(October, 0)) AS Total
        FROM (
            SELECT 
                d.MonthName, 
                cb.p_name AS Filial, 
                (c.UZS_equival / 100) AS CreditIssuance
            FROM vw_CreditIssuance c
            INNER JOIN DimDate d ON d.DateKey = c.DateKey
            INNER JOIN vw_cbus cb ON cb.code_local_3 = c.local_code_3
        ) t
        PIVOT (
            SUM(CreditIssuance)
            FOR MonthName IN (
                January, February, March, April, May, June, July, August, September, October
            )
        ) pt
        ORDER BY Filial;
    """

    print(query)

    result = execute_query_tool.invoke({"query": query})
    print(f"query result:\n{result}")


    if not result or len(result) == 0:
        print({"status": "no_data", "message": "Query returned no results", "data": []})
        return {"status": "no_data", "message": "Query returned no results", "data": []}

    print({"status": "success", "data": result})
    return {"status": "success", "data": result}