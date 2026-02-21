from .example import square, mat_det as _mat_det

def mat_det(a):
    det_a, info = _mat_det(a.shape[0], a)
    if info < 0:
        raise RuntimeError(f'_mat_det error: {info}')
    return det_a
