
import unittest
from todo import Task, TaskPool
from io import StringIO

class TestTaskPool(unittest.TestCase):

    def setUp(self):
        self.pool = TaskPool()

    def test_add_task(self):
        task = Task("New Task")
        self.pool.add_task(task)
        self.assertEqual(len(self.pool.tasks), 1)

    def test_get_open_tasks(self):
        self.pool.populate()
        open_tasks = self.pool.get_open_tasks()
        self.assertEqual(len(open_tasks), 3)
        self.assertTrue(
            all(task.status == "ToDo" for task in open_tasks)
        )

    def test_get_done_tasks(self):
        self.pool.populate()
        done_tasks = self.pool.get_done_tasks()
        self.assertEqual(len(done_tasks), 3)
        self.assertTrue(
            all(task.status == "Done" for task in done_tasks)
        )


if __name__ == "__main__":
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(
        TestTaskPool
    )

    output = StringIO()
    result = unittest.TextTestRunner(
        stream=output, verbosity=2
    ).run(suite)

    print(output.getvalue())

    print(f"Total Tests: {result.testsRun}")
    print(f"Passed: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f"Failed: {len(result.failures) + len(result.errors)}")

    if not result.wasSuccessful():
        raise SystemExit(1)
