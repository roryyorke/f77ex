import unittest
import numpy as np

from foo import mat_det

class TestMatDet(unittest.TestCase):
    def test_mat_det(self):
        a = np.array([[-0.2030663 ,  0.32417689,  0.76633639, -0.45329284,  0.37276521],
                      [ 0.8567029 ,  0.05377543, -1.53308633, -0.64247684, -0.05817236],
                      [-2.06046753,  0.18389118, -0.34021379, -0.13057437, -0.84469368],
                      [ 1.84178557,  1.02015703, -0.16337978,  0.38311857,  0.50142877],
                      [ 1.39550086, -1.005328  , -1.980194  ,  2.04723609, -0.64000547]])
        deta = 1.073871717463714
        
        assert abs(mat_det(a) - deta) < 1e-8 * abs(deta)

if __name__ == '__main__':
    unittest.main()
