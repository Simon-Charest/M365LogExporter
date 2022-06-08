M365 contains valuable information for audit and incident response. This tool was made to ease the export of Unified Audit Logs and their hash values. 

Configuration
Every command requires a date interval. The format is based on the machine's locale. Optionally, you can specify the time as well (format: HH:mm).
When exporting, a data file will be created. A second file will contain the hashes of the exported data. 

Available commands
1. Export log metrics   : Export log metrics, within a date interval, to a CSV file.
2. Export all logs      : Export all available Unified Audit Logs, within a date interval.
3. Export group logs    : Export a group of Unified Audit Logs, within a date interval (e. g., all Exchange, OneDrive or SharePoint logs).
4. Export specific logs : Export a subset of the Unified Audit Logs. The tool needs to be configured with the required AuditLogRecordType. The full list can be found at: https://docs.microsoft.com/en-us/office/office-365-management-api/office-365-management-activity-api-schema#enum-auditlogrecordtype---type-edmint32

Visit the following page for a full README: https://github.com/Simon-Charest/M365LogExporter
