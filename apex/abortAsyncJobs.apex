for (AsyncApexJob job: [
    SELECT Id 
    FROM AsyncApexJob 
    WHERE Status IN ('Processing', 'Queued')
]) {
    try {
        System.abortJob(job.Id);
    } catch (Exception ex) {
        System.debug(ex);
    }
}