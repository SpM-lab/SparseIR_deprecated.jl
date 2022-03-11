using PyCall
import VersionParsing: vparse

const min_sparse_ir_version = "0.7.2"

function check_version_sparse_ir()
    sparse_ir = pyimport("sparse_ir")
    if vparse(sparse_ir.__version__) < vparse(min_sparse_ir_version)
        error(
            "sparse-ir v$(sparse_ir.__version__) is found, but required version >=$(min_sparse_ir_version)! " *
            "PyCall was built with $(PyCall.python)."
            )
    end
end
