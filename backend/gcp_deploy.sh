echo ' 🔶  🔶  🔶 Build Monitor Backend Container Image ... 🔶 '
gcloud builds submit --tag gcr.io/monitor-2021/monitor
if command ; then
    echo "🐤 🐤 Container Build succeeded"
    echo '🌿 🌿 🌿 Deploy Monitor Backend Container on CloudRun ... 🌿 🌿 🌿 '
    gcloud run deploy monitor --image gcr.io/monitor-2021/monitor --platform managed
    if command ; then
        echo '🐤 🐤 🐤 🐤 Monitor Backend Container deployed OK!! 🐤 🐤'
    else
        echo "🔴 🔴 🔴 🔴 🔴 🔴 Deploy failed!"
    fi
else
    echo "🔴 🔴 🔴 🔴 🔴 🔴 Build failed!"
fi




# Service URL: https://monitor-ohgfaci24a-ew.a.run.app
