from datadog_checks.base import AgentCheck
import psycopg2

class PgBouncerClientsCheck(AgentCheck):
    def check(self, instance):
        host = instance.get('host', 'localhost')
        port = instance.get('port', 5432)
        user = instance.get('username')
        password = instance.get('password')
        tags = instance.get('tags', [])

        conn = psycopg2.connect(
            dbname='pgbouncer',
            user=user,
            password=password,
            host=host,
            port=port
        )
        cur = conn.cursor()
        cur.execute("SHOW CLIENTS;")
        rows = cur.fetchall()

        # columns: type, user, database, state, ...
        counts = {}
        for row in rows:
            client_user, db, state = row[1], row[2], row[3]
            key = (client_user, db, state)
            counts[key] = counts.get(key, 0) + 1

        for (client_user, db, state), count in counts.items():
            self.gauge('pgbouncer.client_connections', count, tags=[
                f"user:{client_user}", f"db:{db}", f"state:{state}"
            ] + tags)