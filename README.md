# M365 Log Exporter

M365 contains valuable information for auditing and incident response. This solution was created to ease the export of Unified Audit Logs and their hash values.

Every command requires a date interval. When exporting, a data file will be created. A second file will contain information about the export process. A third file will contain the hashes of the exported data. 

Instead of dealing with sub-loops with up to 10 pages of 5K result sets, with ReturnNextPreviewPage session commands and session ids, it was decided to set the limit results to a single page of 5K. Every time the 5K limit is reached, the interval size will be cut in half before relaunching a search with the same start date. The interval size will be reset the next time the lower limit of 1K (1/5th) results is reached.

## More information
- Data retention:
    - M365 E3: 90 days;
    - M365 E3 with Exchange Online (Plan 1) and M365 Advanced Compliance: 1 year;
    - M365 E5: 1 year;
- Unified Audit Logs are in UTC date format;
- Enabling Mailbox Auditing can take up to 24 hours. Past data will not be available;
- This solution supports Unified Audit Log. It does not support any other type of log (i.e., Message trace, etc.).

## Prerequisites
- The Unified Audit Log Ingestion setting must be enabled in the M365 environment;
- A M365 account, with the View-Only Audit Logs management role and:
    - A M365 E5 license or;
    - A M365 E1 or E3 license, with Advanced eDiscovery or
    - Be an Administrator and a Security & Compliance officer who is assigned to the case;
- One of the following Windows versions:
    - Windows 10;
    - Windows 8.1;
    - Windows 8;
    - Windows 7 SP1;
    - Windows Server 2019;
    - Windows Server 2016;
    - Windows Server 2012 R2;
    - Windows Server 2012;
    - Windows Server 2008 R2 SP1;
- PowerShell;
- PowerShellGet 2.0 or later;
- The Exchange Online PowerShell V2 module.

## Available commands
1. Change tenant: Disconnect from the current tenant then prompt the user for their login credentials for the next one;
2. Check log status: Check if the Unified Audit Log Ingestion setting is Enabled;
3. Export log metrics: Export log metrics, within a date interval, to a CSV file;
4. Export all logs: Export all available Unified Audit Logs, within a date interval, for the specified users;
5. Export Azure logs: Export Azure related Unified Audit Logs, within a date interval, for the specified users;
6. Export Exchange logs: Export Exchange related Unified Audit Logs, within a date interval, for the specified users;
7. Export SharePoint logs: Export SharePoint related Unified Audit Logs, within a date interval, for the specified users;
8. Export Skype logs: Export Skype related Unified Audit Logs, within a date interval, for the specified users;
9. Export specific logs: Export Unified Audit Logs, within a date interval, for the specified users and record types;
10. Show README: Display this information;
11. Show LICENSE: Display license related information;
12. Show ABOUT: Display this solution's information;
13. Exit.

## Output
- metrics.txt: Statistics about the exportable Unified Audit Log data;
- metadata.txt: Information about the export process;
- data.csv: Actual Unified Audit Log exported data;
- hashes.csv: Hashes of the exported CSV files.

## Documentation
- [Search the audit log in the compliance portal](https://docs.microsoft.com/en-us/microsoft-365/compliance/search-the-audit-log-in-security-and-compliance).
